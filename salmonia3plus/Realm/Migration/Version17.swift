//
//  Version17.swift
//  Salmonia3+
//
//  Created by devonly on 2022/12/24
//  Copyright © 2022 Magi Corporation. All rights reserved.
//

import Foundation
import RealmSwift
import Realm

extension RealmMigration {
    /// データを追加
    static func version17(_ migration: Migration) {
        migration.enumerateObjects(ofType: RealmCoopSchedule.className(), { oldValue, newValue in
            if let newValue: DynamicObject = newValue,
               let oldValue: DynamicObject = oldValue
            {
                if let results: List<MigrationObject> = oldValue["results"] as? List<MigrationObject> {
                    /// オオモノ出現数
                    let bossCounts: [List<Int>] = results.compactMap({ result -> List<Int>? in
                        let boss: Int = result["bossId"] as? Int == nil ? 0 : 1
                        if let bossCount: List<Int> = result["bossCounts"] as? List<Int> {
                            let result: [Int] = Array(bossCount).dropLast(1) + [boss]
                            return List<Int>(contentsOf: result)
                        }
                        return List<Int>(contentsOf: Array(repeating: 0, count: 15))
                    })

                    /// オオモノ討伐数
                    let bossKillCounts: [List<Int>] = results.compactMap({ result -> List<Int>? in
                        let boss: Int = result["isBossDefeated"] as? Bool == true ? 1 : 0
                        if let bossKillCount: List<Int> = (result["players"] as? List<MigrationObject>)?.first?["bossKillCounts"] as? List<Int> {
                            let result: [Int] = Array(bossKillCount).dropLast(1) + [boss]
                            return List<Int>(contentsOf: result)
                        }
                        return List<Int>(contentsOf: Array(repeating: 0, count: 15))
                    })

                    /// オオモノ討伐数
                    let bossTeamCounts: [List<Int>] = results.compactMap({ result -> List<Int>? in
                        let boss: Int = result["isBossDefeated"] as? Bool == true ? 1 : 0
                        if let bossCount: List<Int> = result["bossKillCounts"] as? List<Int> {
                            let result: [Int] = Array(bossCount).dropLast(1) + [boss]
                            return List<Int>(contentsOf: result)
                        }
                        return List<Int>(contentsOf: Array(repeating: 0, count: 15))
                    })

                    newValue["bossCounts"] = bossCounts.sum()
                    newValue["bossKillCounts"] = bossKillCounts.sum()
                    newValue["bossTeamCounts"] = bossTeamCounts.sum()
                }
            }
        })
    }
}
