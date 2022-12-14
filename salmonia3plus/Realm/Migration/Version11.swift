//
//  Version11.swift
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
    /// プライマリーキーを設定する
    static func version11(_ migration: Migration) {
        migration.enumerateObjects(ofType: RealmCoopResult.className(), { oldValue, newValue in
            if let newValue: DynamicObject = newValue,
               let oldValue: DynamicObject = oldValue
            {
                if let _ = oldValue["isBossDefeated"] as? Bool {
                    /// 現在オカシラシャケはヨコヅナしかいないので決め打ち
                    newValue["bossId"] = 23
                }

                if let doubleValue: Double = oldValue["dangerRate"] as? Double,
                   let decimalValue: Decimal = Decimal(string: String(format: "%.3f", doubleValue))
                {
                    newValue["dangerRate"] = decimalValue
                }

                if let doubleValue: Double = oldValue["jobRate"] as? Double,
                   let decimalValue: Decimal = Decimal(string: String(format: "%.2f", doubleValue))
                {
                    newValue["jobRate"] = decimalValue
                }
            }
        })
    }
}
