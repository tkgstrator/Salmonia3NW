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
        schemaVersion: 9,
        migrationBlock: RealmMigration.migrationBlock(),
        deleteRealmIfMigrationNeeded: false
    )

    static func migrationBlock() -> MigrationBlock? {
        return { migration, schemaVersion in
            switch schemaVersion {
            case 6:
                version6(migration)
            case 7:
                version7(migration)
            case 8:
                version8(migration)
            default:
                break
            }
        }
    }
}
