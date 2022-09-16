//
//  RealmService.swift
//  Salmonia3+
//
//  Created by devonly on 2022/09/16.
//

import Foundation
import RealmSwift

class RealmService {
    public static let shared = RealmService()
    
    internal var realm: Realm

    private let schemeVersion: UInt64 = 0

    init() {
        let config = Realm.Configuration(
            schemaVersion: schemeVersion,
            deleteRealmIfMigrationNeeded: true
            )
        Realm.Configuration.defaultConfiguration = config
        do {
            self.realm = try Realm()
        } catch (let error) {
            print(error)
            self.realm = try! Realm(configuration: config)
        }
    }
    
    func object<T: Object>(ofType type: T.Type, forPrimaryKey key: String?) -> T? {
        realm.object(ofType: type, forPrimaryKey: key)
    }

    func objects<T: Object>(ofType type: T.Type) -> RealmSwift.Results<T> {
        realm.objects(type)
    }

    func save<T: Object>(_ objects: T) {
        if realm.isInWriteTransaction {
            realm.add(objects, update: .modified)
        } else {
            realm.beginWrite()
            realm.add(objects, update: .modified)
            try? realm.commitWrite()
        }
    }

    func save<T: Object>(_ objects: [T]) {
        if realm.isInWriteTransaction {
            realm.add(objects, update: .modified)
        } else {
            realm.beginWrite()
            realm.add(objects, update: .modified)
            try? realm.commitWrite()
        }
    }

}
