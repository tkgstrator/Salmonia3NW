//
//  Notion.swift
//  Salmonia3+
//  
//  Created by devonly on 2022/12/16
//  Copyright © 2022 Magi Corporation. All rights reserved.
//

import Foundation
import SplatNet3
import Alamofire
import SwiftUI

enum Notion {
    enum StatusType: String, CaseIterable, Codable {
        case 調査中
        case 検討中
        case 未着手
        case テスト中
        case 進行中
        case 完了

        var color: Color {
            switch self {
            case .テスト中:
                return SPColor.SplatNet3.SPBlue
            case .完了:
                return SPColor.SplatNet3.SPBlue
            case .未着手:
                return SPColor.SplatNet3.SPBlue
            case .検討中:
                return SPColor.SplatNet3.SPBlue
            case .調査中:
                return SPColor.SplatNet3.SPBlue
            case .進行中:
                return SPColor.SplatNet3.SPBlue
            }
        }
    }
    
    enum TagType: String, CaseIterable, Codable {
        case 機能追加
        case バグ修正
        case 改善案

        var color: Color {
            switch self {
            case .機能追加:
                return SPColor.SplatNet3.SPOrange
            case .バグ修正:
                return SPColor.SplatNet3.SPOrange
            case .改善案:
                return SPColor.SplatNet3.SPOrange
            }
        }
    }

    class Get: RequestType {
        typealias ResponseType = Response
        var method: HTTPMethod = .post
        var parameters: Parameters? = [:]
        var path: String = "v1/databases/0352102475614fbd83e5d860faef62a5/query"
        var headers: [String : String]?
        var baseURL: URL = URL(unsafeString: "https://api.notion.com/")

        init() {
            self.parameters = [
                "filter": [
                    "property": "ステータス",
                    "status": [
                        "does_not_equal": "完了"
                    ]
                ],
                "sorts": [
                    [
                        "property": "最終更新日",
                        "direction": "descending"
                    ]
                ]
            ]
        }

        struct Response: Codable {
            let results: [Result]
        }

        struct Result: Codable, Identifiable {
            let id: String
            let properties: Property
        }

        struct Property: Codable {
            enum CodingKeys: String, CodingKey {
                case content    = "具体的な内容"
                case status     = "ステータス"
                case title      = "タイトル"
                case tag        = "タグ"
                case version    = "バージョン"
                case progress   = "進捗"
            }

            let content: RichText
            let status: Status
            let title: Title
            let tag: Tag
            let version: Version
            let progress: Progress
        }

        struct Version: Codable {
            let select: Select<String>
        }

        struct Select<T: Codable>: Codable {
            let name: T
        }

        struct Progress: Codable {
            let number: Int?
        }

        struct RichText: Codable {
            let richText: [TitleElement]
        }

        struct Tag: Codable {
            let select: Element<TagType>
        }

        struct Status: Codable {
            let status: Element<StatusType>
        }

        struct Element<T: Codable>: Codable {
            let name: T
        }

        struct Title: Codable {
            let title: [TitleElement]
        }

        struct TitleElement: Codable {
            let plainText: String
        }
    }

    class Post: RequestType {
        typealias ResponseType = Response
        var method: HTTPMethod = .post
        var parameters: Parameters? = [:]
        var path: String = "v1/pages"
        var headers: [String : String]?
        var baseURL: URL = URL(unsafeString: "https://api.notion.com/")

        init(title: String, type: TagType, content: String) {
            self.parameters = [
                "parent": [
                    "database_id": "0352102475614fbd83e5d860faef62a5",
                ],
                "properties": [
                    "タイトル": [
                        "title": [
                            [
                                "text": [
                                    "content": title
                                ]
                            ]
                        ]
                    ],
                    "タグ": [
                        "select": [
                            "name": type.rawValue
                        ]
                    ],
                    "ステータス": [
                        "status": [
                            "name": "未着手"
                        ]
                    ],
                    "具体的な内容": [
                        "rich_text": [
                            [
                                "text": [
                                    "content": content
                                ]
                            ]
                        ]
                    ]
                ]
            ]
        }

        struct Response: Codable {
        }
    }
}
