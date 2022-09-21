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
    @Published var loginProgress: [LoginProgress] = [] {
        willSet {
            isPopuped = !newValue.isEmpty
        }
    }
    @Published var isPopuped: Bool = false
    @Published var isLoading: Bool = false
    @Published var resultCounts: Int = 0
    @Published var resultCountsNum: Int = 0
    @Published private var downloadTask: Task<(), Error>?

    /// エラーログをクラウドに保存するように初期化
    override init() {
        super.init(appId: appId, appSecret: appSecret, encryptionKey: encryptionKey)
    }

    /// WebVersionリクエスト
    override func request(_ request: WebVersion) async throws -> WebVersion.Response {
        // 進行具合に合わせて追加する
        loginProgress.append(LoginProgress(request))

        do {
            let response: WebVersion.Response = try await super.request(request)
            loginProgress.success()
            return response
        } catch(let error) {
            loginProgress.failure()
            throw error
        }
    }

    /// 認証用リクエスト
    override func authorize<T>(_ request: T) async throws -> T.ResponseType where T : RequestType {
        loginProgress.append(LoginProgress(request))

        do {
            let response: T.ResponseType = try await super.authorize(request)
            loginProgress.success()
            return response
        } catch (let error) {
            loginProgress.failure()
            throw error
        }
    }

    /// リザルトを取得して書き込みする
    func getCoopResults() async throws {
        // ローディングを開始する
        self.isLoading.toggle()
        self.resultCounts = 0
        self.resultCountsNum = 0

        let resultId: String? = RealmService.shared.getLatestResultId()

#if DEBUG
        //        let resultIds: [String] = (try await getCoopResultIds(resultId: resultId)).sorted(by: { $0.playTime < $1.playTime })
        let resultIds: [String] = try await getCoopResultIds(resultId: nil).sorted(by: { $0.playTime < $1.playTime })
#else
        let resultIds: [String] = try await getCoopResultIds(resultId: resultId).sorted(by: { $0.playTime < $1.playTime })
#endif

        // 新規リザルトがなければ何もせず閉じる
        if resultIds.isEmpty {
            DispatchQueue.main.asyncAfter(deadline: .now() + 1, execute: {
                self.isLoading.toggle()
            })
            return
        }

        // リザルト取得を開始する
        self.resultCountsNum = resultIds.count

        // リザルト取得を開始する
        _ = try await resultIds.asyncMap({ try await getCoopResult(id: $0) })

        // ローディングを終了する
        DispatchQueue.main.asyncAfter(deadline: .now() + 3, execute: {
            self.isLoading = false
        })
    }

    /// 概要取得
    override func getCoopSummary() async throws -> CoopSummary.Response {
        // 一度削除
        loginProgress.removeAll()
        // GraphQL用のデータを作成
        loginProgress.append(LoginProgress("/api/graphql"))

        do {
            let summary: CoopSummary.Response = try await super.getCoopSummary()
            loginProgress.success()
            return summary
        } catch(let error) {
            loginProgress.failure()
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
            // リザルト書き込みをする
            DispatchQueue.main.async(execute: {
                RealmService.shared.save(result)
            })
            return result
        } catch(let error) {
            loginProgress.failure()
            throw error
        }
    }
}

extension Array where Element == LoginProgress {
    func removeAll() {

    }

    mutating func success() {
        /// 最後のリクエストをSUCCESSにする
        if let _ = self.last {
            self[self.count - 1].progressType = .SUCCESS
        }
    }

    mutating func failure() {
        /// 最後のリクエストをFAILUREにする
        if let _ = self.last {
            self[self.count - 1].progressType = .FAILURE
            /// このままでは消えないので消えるようにする
            DispatchQueue.main.asyncAfter(deadline: .now() + 3, execute: { [self] in
                self.removeAll()
            })
        }
    }
}

struct LoginProgress: Identifiable {
    /// イニシャライザ
    init<T: RequestType>(_ request: T) {
        // 冗長なパスがあるので短くする
        let path: String = request.path
            .replacingOccurrences(of: "connect/1.0.0/", with: "")
            .replacingOccurrences(of: "?id=1234806557", with: "")

        // バージョン取得のやつは更に冗長なので修正
        self.path = {
            if path == "static/js/main.cf1388fb.js" {
                return "api/web_version"
            }
            return path
        }()
    }

    init(_ path: String) {
        self.path = path

    }

    /// 進行度を表すEnum
    enum ProgressType: Int {
        case PROGRESS   = 0
        case SUCCESS    = 1
        case FAILURE    = 2
    }

    /// API種別を表すEnum
    enum APIType: String, CaseIterable {
        case nso    = "NSO"
        case app    = "APP"
        case api    = "API"
        case imink  = "IMINK"
    }

    let path: String

    /// 進行具合(PROGRESS/SUCCESS/FAILURE)
    /// デフォルトは進行中
    var progressType: ProgressType = .PROGRESS

    /// Identifiable
    var id: String { path }

    /// 背景色
    var color: Color {
        switch apiType {
        case .nso:
            return SPColor.Theme.SPGreen
        case .app:
            return SPColor.Theme.SPRed
        case .api:
            return SPColor.Theme.SPBlue
        case .imink:
            return SPColor.Theme.SPPink
        }
    }

    /// APIの種類を返す(NSO/APP/API)
    var apiType: APIType {
        switch path {
        case "api/graphql":
            return .api
        case "api/bullet_tokens":
            return .app
        case "f":
            return .imink
        case "v2/Game/GetWebServiceToken":
            return .app
        case "v3/Account/Login":
            return .app
        case "api/token":
            return .nso
        case "lookup":
            return .api
        case "api/session_token":
            return .nso
        default:
            return .api
        }
    }
}
