//
//  LogButton.swift
//  Salmonia3+
//  
//  Created by devonly on 2022/12/07
//  Copyright © 2022 Magi Corporation. All rights reserved.
//

import SwiftUI
import Alamofire
import SplatNet3

struct LogButton: View {
    @EnvironmentObject var session: Session
    @State private var isPresented: Bool = false

    var body: some View {
        Button(action: {
            isPresented.toggle()
        }, label: {
            Text(bundle: .Custom_Log)
        })
        .confirmationDialog(
            Text(bundle: .Custom_Log_Txt),
            isPresented: $isPresented,
            titleVisibility: .visible,
            actions: {
                Button(action: {
                    Task {
                        do {
                            guard let baseURL: URL = FileManager.default.urls(for: .cachesDirectory, in: .userDomainMask).first else {
                                return
                            }
                            let logURL: URL = baseURL.appendingPathComponent("swiftybeaver").appendingPathExtension("log")
                            let data: Data = try Data(contentsOf: logURL.absoluteURL, options: .uncached)
                            try await session.upload(data: data)
                        } catch(let error) {
                            SwiftyLogger.error(error.localizedDescription)
                        }
                    }
                }, label: {
                    Text(bundle: .Common_Decide)
                })
            }, message: {
                Text(bundle: .Custom_Log_Txt)
            })

    }
}

enum Discord {
    class Message: RequestType {
        typealias ResponseType = Response
        var method: Alamofire.HTTPMethod = .post
        var parameters: Alamofire.Parameters?
        var path: String = discordWebhookPath
        var headers: [String: String]?
        var baseURL: URL = URL(unsafeString: discordWebhookURL)

        init(id: String) {
            let version: String = (Bundle.main.object(forInfoDictionaryKey: "CFBundleShortVersionString") as? String) ?? "1.0.0"
            let build: String = (Bundle.main.object(forInfoDictionaryKey: "CFBundleVersion") as? String) ?? "0"

            self.parameters = [
                "id": id,
                "version": version,
                "build": build,
            ]
        }

        struct Response: Codable {}
    }

    class Attachments: RequestType {
        typealias ResponseType = Response
        var method: Alamofire.HTTPMethod = .post
        var parameters: Alamofire.Parameters? = nil
        var path: String = discordWebhookPath
        var headers: [String : String]?
        var baseURL: URL = URL(unsafeString: discordWebhookURL)

        init() {}

        struct Response: Codable {}

    }
}

struct LogButton_Previews: PreviewProvider {
    static var previews: some View {
        InAppBrowser.WebView(contentId: .SP3)
    }
}
