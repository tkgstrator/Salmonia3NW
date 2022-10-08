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

    /// Versionリクエスト
    override func request(_ request: Version) async throws -> Version.Response {
        // 進行具合に合わせて追加する
        DispatchQueue.main.async(execute: { [self] in
            loginProgress.append(LoginProgress(request))
        })

        do {
            if lists[.VERSION] {
                throw Failure.API(error: NXError.API.response)
            }
            let response: Version.Response = try await super.request(request)
            DispatchQueue.main.async(execute: { [self] in
                loginProgress.success()
            })
            return response
        } catch(let error) {
            DispatchQueue.main.async(execute: { [self] in
                loginProgress.failure()
            })
            dismiss()
            throw error
        }
    }

    /// WebVersionリクエスト
    override func request(_ request: WebVersion) async throws -> WebVersion.Response {
        // 進行具合に合わせて追加する
        DispatchQueue.main.async(execute: { [self] in
            loginProgress.append(LoginProgress(request))
        })

        do {
            if lists[.WEB_VERSION] {
                throw Failure.API(error: NXError.API.response)
            }
            let response: WebVersion.Response = try await super.request(request)
            DispatchQueue.main.async(execute: { [self] in
                loginProgress.success()
            })
            return response
        } catch(let error) {
            DispatchQueue.main.async(execute: { [self] in
                loginProgress.failure()
            })
            dismiss()
            throw error
        }
    }

    /// 認証用リクエスト
    override func authorize<T>(_ request: T) async throws -> T.ResponseType where T : RequestType {
        let progress: LoginProgress = LoginProgress(request)
        DispatchQueue.main.async(execute: { [self] in
            loginProgress.append(progress)
        })
        do {
            if lists[progress.path] {
                throw Failure.API(error: NXError.API.content)
            }
            let response: T.ResponseType = try await super.authorize(request)
            success()
            /// 最初のリクエストと現在リクエストのチェック
            if let first: LoginProgress = loginProgress.first {
                if first.path != .COOP_SUMMARY && progress.path == .BULLET_TOKEN {
                    dismiss()
                }
            }
            return response
        } catch (let error) {
            failure()
            throw error
        }
    }

    func dummy(action: @escaping () -> Void) async {
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.3, execute: { [self] in
            action()
            loginProgress.removeAll()
        })
    }

    /// リザルトを取得して書き込みする
    func getCoopResults() async throws {
        // ローディングを開始する
        DispatchQueue.main.async(execute: { [self] in
            self.resultCounts = 0
            self.resultCountsNum = 0
        })

        /// 最新のバイトID取得
        let resultId: String? = RealmService.shared.getLatestResultId()

        let resultIds: [CoopHistoryElement] = try await {
            if isForceFetch {
                return Array(try await getCoopResultIds(resultId: nil).prefix(Int(maxFetchCounts)))
            }
            return try await getCoopResultIds(resultId: resultId)
        }()

        // 新規リザルトがなければ何もせず閉じる
        if resultIds.isEmpty {
            return
        }

        // 取得すべきリザルトの数
        DispatchQueue.main.async(execute: {[self] in
            self.resultCountsNum = resultIds.count
        })

        do {
            DispatchQueue.main.async(execute: { [self] in
                loginProgress.append(LoginProgress(.COOP_RESULT))
            })
            // リザルト取得を開始する
            _ = try await resultIds.asyncMap({ try await getCoopResult(element: $0) })
            success()
            dismiss()
        } catch(let error) {
            failure()
            throw error
        }
    }

    /// 概要取得
    override func getCoopHistory() async throws -> CoopHistory.Response {
        // GraphQL用のデータを作成
        DispatchQueue.main.async(execute: { [self] in
            loginProgress.append(LoginProgress(.COOP_SUMMARY))
        })

        do {
            let summary: CoopHistory.Response = try await super.getCoopHistory()
            success()
            return summary
        } catch(let error) {
            failure()
            throw error
        }
    }

    @discardableResult
    override func getCoopResult(element: CoopHistoryElement) async throws -> SplatNet2.Result {
        // リザルトを一件取得するごとにカウントアップする
        DispatchQueue.main.async(execute: { [self] in
            resultCounts += 1
        })

        do {
            let result: SplatNet2.Result = try await super.getCoopResult(element: element)

            print(result)
            if !isWritable {
                // リザルト書き込みをする
                DispatchQueue.main.async(execute: {
                    RealmService.shared.save(result)
                })
            }
            return result
        } catch(let error) {
            failure()
            throw error
        }
    }

    /// リクエスト失敗
    func failure() {
        DispatchQueue.main.async(execute: { [self] in
            self.loginProgress.failure()
        })
    }

    /// リクエスト成功
    func success() {
        DispatchQueue.main.async(execute: { [self] in
            self.loginProgress.success()
        })
    }

    /// スタックを全削除
    private func dismiss() {
        DispatchQueue.main.asyncAfter(deadline: .now() + 5, execute: {
            self.loginProgress.removeAll()
        })
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
