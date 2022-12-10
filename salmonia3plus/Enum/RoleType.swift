//
//  TaskType.swift
//  Salmonia3+
//  
//  Created by devonly on 2022/12/10
//  Copyright © 2022 Magi Corporation. All rights reserved.
//

import Foundation
import SwiftUI

enum RoleType: String, CaseIterable {
    case Developer
    case Tester
    case Debuger
    case Translator
}

extension Text {
    init(_ value: RoleType) {
        switch value {
        case .Developer:
            self.init("開発")
        case .Tester:
            self.init("テスト")
        case .Debuger:
            self.init("デバッグ")
        case .Translator:
            self.init("翻訳")
        }
    }
}
