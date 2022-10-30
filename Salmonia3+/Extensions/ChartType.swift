//
//  ChartType.swift
//  Salmonia3+
//
//  Created by devonly on 2022/10/29.
//

import Foundation

enum ChartType: CaseIterable, Hashable {
    /// 個人記録
    case Solo
    /// チーム記録
    case Team
    /// なし
    case None
}

enum ChartIconType: String, CaseIterable, Hashable {
    case GoldenIkura
    case Ikura
    case Death
    case Rescue
    case Salmon
}
