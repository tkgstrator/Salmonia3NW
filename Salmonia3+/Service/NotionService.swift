//
//  NotionService.swift
//  Salmonia3+
//
//  Created by devonly on 2022/11/20.
//

import Foundation
import Alamofire
import Common

class Notion: RequestType {
    typealias ResponseType = Response
    var method: Alamofire.HTTPMethod = .post
    var parameters: Alamofire.Parameters? = [:]
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

class NotionService:  ObservableObject {
    internal let session: Alamofire.Session = Alamofire.Session()

    func request(title: String, type: TagType, content: String) async {
        let request: Notion = Notion(title: title, type: type, content: content)
        request.headers = [
            "Authorization": "Bearer \(notionSecret)",
            "Notion-Version": "2022-06-28"
        ]
        let response = try? await session.request(request)
            .serializingString()
            .value
        print(response)
    }
}
