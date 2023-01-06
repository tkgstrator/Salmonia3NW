//
//  Version16.swift
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
    static func version16(_ migration: Migration) {
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

        var ids: [String] = []
        migration.enumerateObjects(ofType: RealmCoopPlayer.className(), { oldValue, newValue in
            if let newValue: DynamicObject = newValue,
               let oldValue: DynamicObject = oldValue
            {
                /// 変換不可能なものは削除
                guard let stringValue: String = oldValue["id"] as? String else {
                    migration.delete(newValue)
                    return
                }

                /// プライマリキーを更新する
                let id: String = {
                    if let id: String = stringValue.base64DecodedString {
                        return id
                    }
                    return stringValue
                }()

                if ids.contains(id) {
                    migration.delete(newValue)
                    return
                }

                /// 新しく追加
                ids.append(id)

                if let uid: String = id.capture(pattern: #":u-([0-9a-z]*)"#, group: 1) {
                    newValue["id"] = id
                    newValue["uid"] = uid
                }
            }
        })
    }
}
