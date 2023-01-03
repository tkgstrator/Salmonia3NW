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
    /// 重複してそうなスケジュールを削除する
    static func version6(_ migration: Migration) {
        let dateFormatter = ISO8601DateFormatter()
        let limitTime: Date = dateFormatter.date(from: "2022-12-02T08:00:00Z")!

        migration.enumerateObjects(ofType: RealmCoopSchedule.className(), { oldValue, newValue in
            if let newValue: DynamicObject = newValue, let oldValue: DynamicObject = oldValue {
                if let startTime: Date = oldValue["startTime"] as? Date
                {
                    if startTime >= limitTime {
                        migration.delete(newValue)
                    }
                }
            }
        })
    }
}
