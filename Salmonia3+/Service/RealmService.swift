//
//  RealmService.swift
//  Salmonia3+
//
//  Created by devonly on 2022/09/16.
//

import Foundation
import RealmSwift
import SplatNet3
import SwiftUI

class RealmService {
    public static let shared = RealmService()
    
    internal var realm: Realm

    private let schemeVersion: UInt64 = 0
    @AppStorage("IS_FIRST_LAUNCH") var isFirstLaunch: Bool = false

    init() {
        let config = Realm.Configuration(
            schemaVersion: schemeVersion,
            deleteRealmIfMigrationNeeded: true
            )
        Realm.Configuration.defaultConfiguration = config
        do {
            self.realm = try Realm()
        } catch (let error) {
            self.realm = try! Realm(configuration: config)
        }
    }

    func deleteAll() {
        isFirstLaunch.toggle()
        if realm.isInWriteTransaction {
            realm.deleteAll()
        } else {
            do {
                try realm.write({
                    realm.deleteAll()
                })
            } catch(let error) {
                print(error)
            }
        }
    }

    /// 最も新しいリザルトIDを取得する
    func getLatestResultId() -> String? {
        realm.objects(RealmCoopResult.self).max(by: { $0.playTime < $1.playTime })?.id
    }
    
    func object<T: Object>(ofType type: T.Type, forPrimaryKey key: String?) -> T? {
        realm.object(ofType: type, forPrimaryKey: key)
    }

    func objects<T: Object>(ofType type: T.Type) -> RealmSwift.Results<T> {
        realm.objects(type)
    }

    /// リザルト複数書き込み(ただし、そんなに速くない)
    func save(_ results: [SplatNet2.Result]) {
        _ = results.map({ save($0) })
    }

    /// リザルト一件書き込み
    func save(_ result: SplatNet2.Result) {
        // スケジュール情報を取得, なければ作成する
        let schedule: RealmCoopSchedule = {
            if let schedule = realm.objects(RealmCoopSchedule.self).first(where: {
                $0.stageId == result.schedule.stage &&
                Array($0.weaponList) == result.schedule.weaponLists &&
                $0.rule == result.rule
            }) {
                return schedule
            }

            let schedule: RealmCoopSchedule = RealmCoopSchedule(from: result)
            if realm.isInWriteTransaction {
                realm.add(schedule, update: .modified)
            } else {
                realm.beginWrite()
                realm.add(schedule, update: .modified)
                try? realm.commitWrite()
            }

            return schedule
        }()

        // リザルト存在チェック(Listへのappendではプライマリーキー制約が判定されないので)
        if realm.object(ofType: RealmCoopResult.self, forPrimaryKey: result.id) == nil {
            // リザルト作成
            let object: RealmCoopResult = RealmCoopResult(from: result)

            // リザルト書き込み
            if realm.isInWriteTransaction {
                schedule.results.append(object)
            } else {
                realm.beginWrite()
                schedule.results.append(object)
                try? realm.commitWrite()
            }
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
