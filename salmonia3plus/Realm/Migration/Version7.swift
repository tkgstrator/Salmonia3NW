//
//  Version7.swift
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
    static func version7(_ migration: Migration) {
        /// スケジュールはハッシュを書き換えるだけ
        migration.enumerateObjects(ofType: RealmCoopSchedule.className(), { oldValue, newValue in
            if let newValue: DynamicObject = newValue,
               let oldValue: DynamicObject = oldValue
            {
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
                newValue["uniform"] = 1
            }
        })
    }
}
