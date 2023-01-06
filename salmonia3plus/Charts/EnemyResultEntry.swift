//
//  EnemyResultEntry.swift
//  Salmonia3+
//  
//  Created by devonly on 2023/01/07
//  Copyright © 2023 Magi Corporation. All rights reserved.
//

import Foundation
import SplatNet3

struct EnemyResultEntry: Identifiable {
    /// ID
    var id: UUID = UUID()
    /// スケジュール
//    let schedule: RealmCoopSchedule
    /// オオモノID
    let enemyKey: EnemyKey
    /// スケジュールID
    let scheduleId: Date
    /// オオモノ出現数
    let bossCount: EnemyCount
    /// オオモノ討伐数
    let bossKillCount: EnemyKillCount
    /// オオモノ累計討伐数
    let bossKillTotal: EnemyKillCount

    var bossKillRatio: Decimal {
        if bossCount.shift == .zero {
            return .zero
        }
        let stringValue: String = String(format: "%.3f", Double(bossKillCount.solo) / Double(bossCount.shift))
        return Decimal(string: stringValue) ?? .zero
    }
}
