//
//  Version8.swift
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
    static func version8(_ migration: Migration) {
        /// プレイヤーのユニフォーム情報を設定
        migration.enumerateObjects(ofType: RealmCoopPlayer.className(), { oldValue, newValue in
            if let newValue: DynamicObject = newValue,
               let oldValue: DynamicObject = oldValue
            {
                newValue["uniform"] = 1
            }
        })

        /// クリアしたかどうかの情報を追加
        migration.enumerateObjects(ofType: RealmCoopWave.className(), { oldValue, newValue in
            if let newValue: DynamicObject = newValue
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

        /// オカシラシャケの情報を追加
        migration.enumerateObjects(ofType: RealmCoopResult.className(), { oldValue, newValue in
            if let newValue: DynamicObject = newValue,
               let oldValue: DynamicObject = oldValue
            {
                if let _ = oldValue["isBossDefeated"] as? Bool {
                    /// 現在オカシラシャケはヨコヅナしかいないので決め打ち
                    newValue["bossId"] = 23
                }
            }
        })
    }
}
