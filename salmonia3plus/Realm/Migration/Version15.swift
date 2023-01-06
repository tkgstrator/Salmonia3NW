//
//  Version15.swift
//  Salmonia3+
//
//  Created by devonly on 2022/12/24
//  Copyright © 2022 Magi Corporation. All rights reserved.
//

import Foundation
import RealmSwift
import CryptoKit
import SplatNet3

extension RealmMigration {
    /// プライマリーキーを設定する
    static func version15(_ migration: Migration) {
        migration.enumerateObjects(ofType: RealmCoopResult.className(), { oldValue, newValue in
            if let newValue: DynamicObject = newValue,
               let oldValue: DynamicObject = oldValue
            {
                if let stringValue: String = oldValue["id"] as? String,
                   let uuid: String = stringValue.capture(pattern: #"_([a-f0-9\-]{36})$"#, group: 1) {
                    newValue["uuid"] = uuid
                }
            }
        })
    }
}
