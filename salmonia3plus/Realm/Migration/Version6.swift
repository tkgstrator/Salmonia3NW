//
//  Version6.swift
//  Salmonia3+
//  
//  Created by devonly on 2022/12/03
//  Copyright © 2022 Magi Corporation. All rights reserved.
//

import Foundation
import RealmSwift
import Realm
import CryptoKit

extension RealmMigration {
    static func version6(_ migration: Migration) {
        /// スケジュールはハッシュを書き換えるだけ
        migration.enumerateObjects(ofType: RealmCoopSchedule.className(), { oldValue, newValue in
            if let newValue: DynamicObject = newValue,
               let oldValue: DynamicObject = oldValue
            {
                /// 通常のシフトの仮ハッシュ計算
                if let startTime: Date = oldValue["startTime"] as? Date,
                   let endTime: Date = oldValue["endTime"] as? Date,
                   let stageId: Int = oldValue["stageId"] as? Int,
                   let rule: String = oldValue["rule"] as? String,
                   let mode: String = oldValue["mode"] as? String,
                   let weaponList: RealmSwift.List<Int> = oldValue["weaponList"] as? RealmSwift.List<Int>
                {
                    newValue["id"] = SHA256.resultHash(startTime: startTime, endTime: endTime, stageId: stageId, rule: rule, mode: mode, weaponList: Array(weaponList))
                    return
                }

                /// プライベートシフトの仮ハッシュ計算
                if let stageId: Int = oldValue["stageId"] as? Int,
                   let rule: String = oldValue["rule"] as? String,
                   let mode: String = oldValue["mode"] as? String,
                   let weaponList: RealmSwift.List<Int> = oldValue["weaponList"] as? RealmSwift.List<Int>
                {
                    newValue["id"] = SHA256.resultHash(stageId: stageId, rule: rule, mode: mode, weaponList: Array(weaponList))
                    return
                }
            }
        })

        migration.enumerateObjects(ofType: RealmCoopPlayer.className(), { oldValue, newValue in
            if let newValue: DynamicObject = newValue,
               let oldValue: DynamicObject = oldValue
            {
                if let specialId: Int = oldValue["specialId"] as? Int {
                    newValue["specialId"] = specialId
                }
                newValue["uniform"] = 1
            }
        })

        migration.enumerateObjects(ofType: RealmCoopWave.className(), { oldValue, newValue in
            if let newValue: DynamicObject = newValue,
               let oldValue: DynamicObject = oldValue
            {
                if let results: RLMResults<RealmCoopResult> = newValue["link"] as? RLMResults<RealmCoopResult>,
                   let result: RealmCoopResult = results.firstObject(),
                   let waveId: Int = newValue["id"] as? Int
                {
                    if let failureWave: Int = result["failureWave"] as? Int {
                        newValue["isClear"] = failureWave != waveId
                        return
                    }
                    if let isDefeated: Bool = result["isBossDefeated"] as? Bool {
                        if waveId != 4 {
                            newValue["isClear"] = true
                            return
                        }
                        newValue["isClear"] = isDefeated
                        return
                    }
                    newValue["isClear"] = true
                    return
                }
            }
        })

        migration.enumerateObjects(ofType: RealmCoopResult.className(), { oldValue, newValue in
            if let newValue: DynamicObject = newValue,
               let oldValue: DynamicObject = oldValue
            {
                if let dangerRate: Double = oldValue["dangerRate"] as? Double {
                    newValue["dangerRate"] = dangerRate
                }
                if let jobRate: Double = oldValue["jobRate"] as? Double {
                    newValue["jobRate"] = jobRate
                }
                if let _ = oldValue["isBossDefeated"] as? Bool {
                    /// 現在オカシラシャケはヨコヅナしかいないので決め打ち
                    newValue["bossId"] = 23
                }
            }
        })
    }
}
