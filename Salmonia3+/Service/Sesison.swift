//
//  Session.swift
//  Salmonia3+
//
//  Created by devonly on 2022/09/18.
//

import Foundation
import SplatNet3
import Common
import SwiftUI

class Session: SplatNet3, ObservableObject {
    @Published var loginProgress: [LoginProgress] = []
    /// 取得中のリザルトの数
    @Published var resultCounts: Int = 0
    /// 取得すべきリザルトの数
    @Published var resultCountsNum: Int = 0
    /// エラーテスト
    @AppStorage("IS_DEBUG_ERROR_SESSION") var lists: [Bool] = Array(repeating: false, count: SPEndpoint.allCases.count)
    /// リザルト強制取得
    @AppStorage("IS_DEBUG_FORCE_FETCH") var isForceFetch: Bool = false
    /// リザルトを書き込まない
    @AppStorage("IS_DEBUG_DONOT_WRITE") var isWritable: Bool = false
    /// 最大取得件数
    @AppStorage("IS_DEBUG_MAX_FETCH_COUNTS") var maxFetchCounts: Double = 50

    /// エラーログをクラウドに保存するように初期化
    override init() {
        super.init(appId: appId, appSecret: appSecret, encryptionKey: encryptionKey)
    }

    /// ポップアップを閉じるだけの処理
    private func dismiss() {
        DispatchQueue.main.asyncAfter(deadline: .now() + 3, execute: { [self] in
            self.loginProgress.removeAll()
        })
    }

    /// WebVersionリクエスト
    override func request(_ request: WebVersion) async throws -> WebVersion.Response {
        // 進行具合に合わせて追加する
        loginProgress.append(LoginProgress(request))

        do {
            if lists[.WEB_VERSION] {
                throw Failure.API(error: NXError.API.content)
            }
            let response: WebVersion.Response = try await super.request(request)
            loginProgress.success()
            return response
        } catch(let error) {
            loginProgress.failure()
            dismiss()
            throw error
        }
    }

    /// 認証用リクエスト
    override func authorize<T>(_ request: T) async throws -> T.ResponseType where T : RequestType {
        let progress: LoginProgress = LoginProgress(request)
        loginProgress.append(progress)

        do {
            if lists[progress.path] {
                throw Failure.API(error: NXError.API.content)
            }
            let response: T.ResponseType = try await super.authorize(request)
            loginProgress.success()
            /// 最初のリクエストと現在リクエストのチェック
            if let first: LoginProgress = loginProgress.first {
                if first.path != .COOP_SUMMARY && progress.path == .BULLET_TOKEN {
                    dismiss()
                }
            }
            return response
        } catch (let error) {
            loginProgress.failure()
            dismiss()
            throw error
        }
    }

    /// リザルトを取得して書き込みする
    func getCoopResults() async throws {
        // ローディングを開始する
        self.resultCounts = 0
        self.resultCountsNum = 0

        /// 最新のバイトID取得
        let resultId: String? = RealmService.shared.getLatestResultId()

        let resultIds: [String] = try await {
            if isForceFetch {
                return Array((try await getCoopResultIds(resultId: nil).sorted(by: { $0.playTime < $1.playTime })).prefix(Int(maxFetchCounts)))
            }
            return try await getCoopResultIds(resultId: resultId).sorted(by: { $0.playTime < $1.playTime })
        }()

        // 新規リザルトがなければ何もせず閉じる
        if resultIds.isEmpty {
            return
        }

        // 取得すべきリザルトの数
        self.resultCountsNum = resultIds.count

        do {
            loginProgress.append(LoginProgress(.COOP_RESULT))
            // リザルト取得を開始する
            _ = try await resultIds.asyncMap({ try await getCoopResult(id: $0) })
            loginProgress.success()
            dismiss()
        } catch(let error) {
            loginProgress.failure()
            dismiss()
            throw error
        }
    }

    /// 概要取得
    override func getCoopSummary() async throws -> CoopSummary.Response {
        // GraphQL用のデータを作成
        loginProgress.append(LoginProgress(.COOP_SUMMARY))

        do {
            let summary: CoopSummary.Response = try await super.getCoopSummary()
            loginProgress.success()
            return summary
        } catch(let error) {
            loginProgress.failure()
            dismiss()
            throw error
        }
    }

    /// リザルトのID取得
    override func getCoopResultIds(resultId: String? = nil) async throws -> [String] {
        let ids: [String] = try await super.getCoopResultIds(resultId: resultId)
        return ids
    }

    @discardableResult
    override func getCoopResult(id: String) async throws -> SplatNet2.Result {
        // リザルトを一件取得するごとにカウントアップする
        resultCounts += 1

        do {
            let result: SplatNet2.Result = try await super.getCoopResult(id: id)

            if !isWritable {
                // リザルト書き込みをする
                DispatchQueue.main.async(execute: {
                    RealmService.shared.save(result)
                })
            }
            return result
        } catch(let error) {
            loginProgress.failure()
            dismiss()
            throw error
        }
    }
}

private extension Array where Element == Bool {
    subscript(_ request: SPEndpoint) -> Bool {
        if let index: Int = SPEndpoint.allCases.firstIndex(of: request) {
            return self[index]
        }
        return false
    }
}
