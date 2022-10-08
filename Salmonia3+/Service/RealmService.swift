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

    private let schemeVersion: UInt64 = 4

    internal var realm: Realm {
        get {
            #if DEBUG
            let config = Realm.Configuration(
                schemaVersion: schemeVersion,
                deleteRealmIfMigrationNeeded: false
            )
            #else
            let config = Realm.Configuration(
                schemaVersion: schemeVersion,
                deleteRealmIfMigrationNeeded: true
            )
            #endif
            Realm.Configuration.defaultConfiguration = config
            do {
                return try Realm()
            } catch (let error) {
                return try! Realm(configuration: config)
            }
        }
    }

    init() {}

    func getCoopRegularSchedule() {
        Task(priority: .background, operation: {
            let session: Session = Session()
            let schedules: [CoopSchedule] = try await session.getCoopSchedule()
//            let objects: [RealmCoopSchedule]
            print(schedules)
        })
    }

    func deleteAll() {
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
        return realm.objects(RealmCoopResult.self).max(by: { $0.playTime < $1.playTime })?.id
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

    func save(_ schedules: [CoopSchedule]) {
        for schedule in schedules {
            save(schedule)
        }
    }

    private func save(_ schedule: CoopSchedule) {
        // 抜けているステージ情報があるかどうか
        if let schedule = realm.objects(RealmCoopSchedule.self).first(where: {
            // ステージが一致
            $0.stageId == schedule.stage &&
            /// 支給ブキが一致
            Array($0.weaponList) == schedule.weaponList &&
            /// プライベートバイトではない
            $0.rule == schedule.rule &&
            /// モードが一致している
            $0.mode == schedule.mode &&
            /// 時刻情報が抜けている
            $0.startTime == nil && $0.endTime == nil
        }) {
            if realm.isInWriteTransaction {
                schedule.startTime = schedule.startTime
                schedule.endTime = schedule.endTime
            } else {
                try? realm.write {
                    schedule.startTime = schedule.startTime
                    schedule.endTime = schedule.endTime
                }
            }
        }
        // 追加されていないステージ情報があるかどうか
        guard let _ = realm.objects(RealmCoopSchedule.self).first(where: { $0.startTime == schedule.startTime }) else {
            // 追加されていないステージがあればDBに書き込む
            let schedule: RealmCoopSchedule = RealmCoopSchedule(from: schedule)
            save(schedule)
            return
        }
    }

    /// リザルト一件書き込み
    func save(_ result: SplatNet2.Result) {
        // スケジュール情報を取得, なければ作成する
        let schedule: RealmCoopSchedule = {
            if let schedule = realm.objects(RealmCoopSchedule.self).first(where: {
                $0.stageId == result.schedule.stage &&
                Array($0.weaponList) == result.schedule.weaponLists &&
                $0.rule == result.schedule.rule &&
                $0.mode == result.schedule.mode
            }) {
                return schedule
            }

            let schedule: RealmCoopSchedule = RealmCoopSchedule(from: result)
            if realm.isInWriteTransaction {
                realm.add(schedule)
            } else {
                realm.beginWrite()
                realm.add(schedule)
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

    func save<T: Object>(_ object: T) {
        if realm.isInWriteTransaction {
            realm.add(object)
        } else {
            realm.beginWrite()
            realm.add(object)
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
