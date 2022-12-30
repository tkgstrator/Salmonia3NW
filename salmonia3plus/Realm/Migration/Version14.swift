//
//  Version14.swift
//  Salmonia3+
//
//  Created by devonly on 2022/12/24
//  Copyright © 2022 Magi Corporation. All rights reserved.
//

import Foundation
import RealmSwift
import Realm
import CryptoKit
import SplatNet3

extension RealmMigration {
    /// プライマリーキーを設定する
    static func version14(_ migration: Migration) {
        migration.enumerateObjects(ofType: RealmCoopResult.className(), { oldValue, newValue in
            if let newValue: DynamicObject = newValue,
               let oldValue: DynamicObject = oldValue
            {
                if let gradeId: Int = oldValue["grade"] as? Int {
                    newValue["gradeId"] = gradeId
                }
                let decoder: JSONDecoder = JSONDecoder()
                decoder.keyDecodingStrategy = .convertFromSnakeCase
                if let stringValue: String = oldValue["id"] as? String,
                   let data: Data = stringValue.data(using: .utf8),
                   let id: Common.ResultId = try? decoder.decode(Common.ResultId.self, from: data)
                {
                    newValue["uuid"] = id.uuid
                }
            }
        })
        migration.enumerateObjects(ofType: RealmCoopPlayer.className(), { oldValue, newValue in
            if let newValue: DynamicObject = newValue {
                newValue["textColor"] = [1, 1, 1, 1]
            }
        })
    }
}
