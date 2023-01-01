//
//  RealmMigration.swift
//  Salmonia3+
//  
//  Created by devonly on 2022/12/03
//  Copyright © 2022 Magi Corporation. All rights reserved.
//

import Foundation
import RealmSwift
import SplatNet3

enum RealmMigration {
    static let configuration: Realm.Configuration = Realm.Configuration(
        schemaVersion: 16,
        migrationBlock: RealmMigration.migrationBlock(),
        deleteRealmIfMigrationNeeded: false
//        shouldCompactOnLaunch: { totalBytes, usedBytes in
//            let used: Double = Double(usedBytes) / Double(totalBytes)
//            SwiftyLogger.verbose("Size:\(totalBytes) Used:\(usedBytes) Percentage:\(used)")
//            /// DBサイズが10MB以上で使用率が50%を切っていたら圧縮する
//            if totalBytes >= 10 * 1024 * 1024 && used <= 0.5 {
//                return true
//            }
//            return false
//        }
    )

    static func migrationBlock() -> MigrationBlock? {
        return { migration, schemaVersion in
            print("SchemaVersion", schemaVersion)
            if schemaVersion <= 6 {
                version6(migration)
            }
            if schemaVersion <= 7 {
                version7(migration)
            }
            if schemaVersion <= 8 {
                version8(migration)
            }
            if schemaVersion <= 11 {
                version11(migration)
            }
            if schemaVersion <= 12 {
                version12(migration)
            }
            if schemaVersion <= 13 {
                version13(migration)
            }
            if schemaVersion <= 14 {
                version14(migration)
            }
            if schemaVersion <= 15 {
                version15(migration)
            }
        }
    }
}
