//
//  Discord.swift
//  Salmonia3+
//  
//  Created by devonly on 2022/12/16
//  Copyright © 2022 Magi Corporation. All rights reserved.
//

import Foundation
import SplatNet3
import Alamofire

enum Discord {
    class Message: RequestType {
        typealias ResponseType = Response
        var method: HTTPMethod = .post
        var parameters: Parameters?
        var path: String = discordWebhookPath
        var headers: [String: String]?
        var baseURL: URL = URL(unsafeString: discordWebhookURL)

        init(context: String) {
            self.parameters = [
                "content": context
            ]
        }

        struct Response: Codable {}
    }

    class Attachments: RequestType {
        typealias ResponseType = Response
        var method: HTTPMethod = .post
        var parameters: Parameters? = nil
        var path: String = discordWebhookPath
        var headers: [String : String]?
        var baseURL: URL = URL(unsafeString: discordWebhookURL)

        init() {}

        struct Response: Codable {}

    }
}
