//
//  TagType.swift
//  Salmonia3+
//
//  Created by devonly on 2022/11/20.
//

import Foundation

enum TagType: String, CaseIterable, Identifiable {
    var id: String { rawValue }

    case バグ修正
    case 機能追加
    case 改善案
}
