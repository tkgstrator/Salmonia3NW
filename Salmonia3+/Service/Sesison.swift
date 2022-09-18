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
    @Published var isPopuped: Bool = false
    @Published var resultCounts: Int = 0

    override func authorize<T>(_ request: T) async throws -> T.ResponseType where T : RequestType {
        if loginProgress.isEmpty || loginProgress.count >= 8 {
            isPopuped = true
        }
        // 進行具合に合わせて追加する
        let progress: LoginProgress = LoginProgress(path: request.path)
        loginProgress.append(progress)

        // 多い場合は削除する
        if loginProgress.count >= 8 {
            DispatchQueue.main.asyncAfter(deadline: .now() + 5, execute: {
                self.loginProgress.removeAll()
                self.isPopuped = false
            })
        }

        // 通信待ち状態
        do {
            let response: T.ResponseType = try await super.authorize(request)
            // 成功したので状態を更新
            if !loginProgress.isEmpty {
                loginProgress[loginProgress.count - 1].progressType = .success
            }
            return response
        } catch (let error) {
            // 失敗したので状態を更新
            if !loginProgress.isEmpty {
                loginProgress[loginProgress.count - 1].progressType = .failure
            }
            throw error
        }
    }

    /// リザルトを取得して書き込みする
    func getCoopResults() async throws {
        let resultId: String? = RealmService.shared.getLatestResultId()
        let resultIds: [String] = try await getCoopResultIds(resultId: resultId)

        // 新規リザルトがなければ何もしない
        if resultIds.isEmpty {
            return
        }
        // リザルト取得を開始する
        self.resultCounts = resultIds.count
        let results: [SplatNet2.Result] = try await resultIds.asyncMap({ try await getCoopResult(id: $0) })
        DispatchQueue.main.async(execute: {
            RealmService.shared.save(results)
        })
    }

    override func getCoopResultIds(resultId: String? = nil) async throws -> [String] {
        let ids: [String] = try await super.getCoopResultIds(resultId: resultId)
        print(ids.count)
        return ids
    }

    @discardableResult
    override func getCoopResult(id: String) async throws -> SplatNet2.Result {
        return try await super.getCoopResult(id: id)
    }
}

struct LoginProgress: Identifiable {
    init(path: String) {
        self.path = path
            .replacingOccurrences(of: "connect/1.0.0/", with: "")
            .replacingOccurrences(of: "?id=1234806557", with: "")
    }

    enum ProgressType: Int {
        case progress   = 0
        case success    = 1
        case failure    = 2
    }

    enum APIType: String, CaseIterable {
        case nso    = "NSO"
        case app    = "APP"
        case api    = "API"
        case imink  = "IMINK"
    }

    let path: String
    var progressType: ProgressType = .progress
    var id: String { path }
    var color: Color {
        switch apiType {
        case .nso:
            return Color(hex: "1ACE3B")
        case .app:
            return Color(hex: "D33826")
        case .api:
            return Color(hex: "BC08F5")
        case .imink:
            return Color(hex: "FF318E")
        }
   }

    var apiType: APIType {
        switch path {
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
