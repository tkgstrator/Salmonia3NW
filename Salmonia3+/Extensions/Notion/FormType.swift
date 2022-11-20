//
//  TagType.swift
//  Salmonia3+
//
//  Created by devonly on 2022/11/20.
//

import Foundation
import SplatNet3

enum TagType: String, CaseIterable, Identifiable {
    var id: String { rawValue }

    case バグ修正
    case 機能追加
    case 改善案

    var localized: LocalizedType {
        switch self {
        case .バグ修正:
            return .Common_Form_Type_Bug
        case .機能追加:
            return .Common_Form_Type_Feature
        case .改善案:
            return .Common_Form_Type_Enhancement
        }
    }
}
