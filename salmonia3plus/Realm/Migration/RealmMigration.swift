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
        schemaVersion: 13,
        migrationBlock: RealmMigration.migrationBlock(),
        deleteRealmIfMigrationNeeded: false
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
                version11(migration)
            }
        }
    }
}
