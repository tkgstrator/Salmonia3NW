//
//  NSScriptContent.swift
//  Salmonia3+
//
//  Created by devonly on 2022/11/17.
//

import Foundation

enum NSScriptContent {
    case closeWebView
    case reloadExtension
    case completeLoading
    case invokeNativeShare(Share)
    case invokeNativeShareUrl(ShareURL)
    case copyToClipboard(String)
    case downloadimages([String])

    struct Share: Codable {
        let text: String
        let imageUrl: String
        let hashtags: [String]
    }

    struct ShareURL: Codable {
        let text: String
        let url: String
    }
}
