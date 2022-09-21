//
//  LoginProgress.swift
//  Salmonia3+
//
//  Created by devonly on 2022/09/21.
//

import Foundation
import Common
import SplatNet3
import SwiftUI

struct LoginProgress: Identifiable {
    /// イニシャライザ
    init<T: RequestType>(_ request: T) {
        // 冗長なパスがあるので短くする
        let path: String = request.path
            .replacingOccurrences(of: "connect/1.0.0/", with: "")
            .replacingOccurrences(of: "?id=1234806557", with: "")

        // バージョン取得のやつは更に冗長なので修正
        self.path = {
            if let value: SPEndpoint = SPEndpoint(rawValue: path) {
                return value
            }
            if path == "static/js/main.cf1388fb.js" {
                return .WEB_VERSION
            }
            return .UNKNOWN
        }()
    }

    init(_ endpoint: SPEndpoint) {
        self.path = endpoint
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

    let path: SPEndpoint

    /// 進行具合(PROGRESS/SUCCESS/FAILURE)
    /// デフォルトは進行中
    var progressType: ProgressType = .PROGRESS

    /// Identifiable
    var id: String { path.rawValue }

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
        case .COOP_SUMMARY, .COOP_RESULT, .VERSION, .WEB_VERSION:
            return .api
        case .SPLATOON_ACCESS_TOKEN, .SPLATOON_TOKEN:
            return .app
        case .F:
            return .imink
        case .SESSION_TOKEN, .ACCESS_TOKEN:
            return .nso
        default:
            return .api
        }
    }
}

extension Array where Element == LoginProgress {
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
        }
    }
}
