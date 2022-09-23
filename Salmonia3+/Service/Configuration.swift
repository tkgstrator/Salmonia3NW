//
//  Configuration.swift
//  Salmonia3+
//
//  Created by devonly on 2022/09/23.
//

import Foundation
import SwiftUI

/// アプリ設定(将来的に書き直したい)
class APPConfiguration: ObservableObject {
    /// アプリのカラーテーマ
    @AppStorage("CONFIG_IS_FIRST_LAUNCH") var isFirstLaunch: Bool = true
    
    /// アプリのカラーテーマ
    @AppStorage("CONFIG_COLOR_SCHEME") var colorScheme: Bool = false

    /// リザルト一覧での回転形式
    @AppStorage("CONFIG_ROTATION_EFFECT") var rotationEffect: Bool = false

    /// リザルト一覧の表示形式
    @AppStorage("CONFIG_REULTS_STYLE") var resultsStyle: Bool = false

    /// プレイヤーの背景表示形式
    @AppStorage("CONFIG_BACKGROUND_STYLE") var backgroundStyle: Bool = false
}
