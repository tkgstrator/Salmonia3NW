//
//  RealmMigration.swift
//  Salmonia3+
//  
//  Created by devonly on 2022/12/03
//  Copyright © 2022 Magi Corporation. All rights reserved.
//

import Foundation
import RealmSwift

enum RealmMigration {
    static let configuration: Realm.Configuration = Realm.Configuration(
        schemaVersion: 11,
        migrationBlock: RealmMigration.migrationBlock(),
        deleteRealmIfMigrationNeeded: false
    )

    static func migrationBlock() -> MigrationBlock? {
        return { migration, schemaVersion in
            print(schemaVersion)
            switch schemaVersion {
            case 6:
                /// 1.2.1からのアップデート
                version6(migration)
            default:
                break
            }
        }
    }
}
