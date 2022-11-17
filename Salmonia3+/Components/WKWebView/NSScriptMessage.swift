//
//  NSScriptMessage.swift
//  Salmonia3+
//
//  Created by devonly on 2022/11/17.
//

import Foundation

/// イカリング3が送ってくるメッセージ
enum NSScriptMessage: String, CaseIterable {
    case closeWebView
    case reloadExtension
    case completeLoading
    case invokeNativeShare
    case invokeNativeShareUrl
    case copyToClipboard
    case downloadimages
}
