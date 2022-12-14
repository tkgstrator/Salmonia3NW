//
//  Version12.swift
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
    static func version12(_ migration: Migration) {
        migration.enumerateObjects(ofType: RealmCoopPlayer.className(), { oldValue, newValue in
            if let newValue: DynamicObject = newValue,
               let oldValue: DynamicObject = oldValue
            {
                if let id: String = oldValue["id"] as? String,
                   let uid: String = id.capture(pattern: #":u-([0-9a-z]*)"#, group: 1) {
                    newValue["uid"] = uid
                }
            }
        })
    }
}
