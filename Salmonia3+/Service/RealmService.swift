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

    /// JSONに変換して出力するやつ
    func exportToJSON() -> [JSONCoopResult] {
        realm.objects(RealmCoopResult.self).map({ JSONCoopResult(result: $0) })
    }

    /// スケジュールを取得して書き込む
    func getCoopRegularSchedule() {
        Task(priority: .background, operation: {
            let session: Session = Session()
            let schedules: [CoopSchedule.Response] = try await session.getCoopSchedule()
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

    /// スケジュールを書き込む
    func save(_ schedules: [CoopSchedule.Response]) {
        for schedule in schedules {
            save(schedule)
        }
    }

    /// ステージ情報を書き込む
    /// コード自体はあっているので後でもっとより良いものに修正する
    private func save(_ schedule: CoopSchedule.Response) {
        let result: RealmCoopSchedule = RealmCoopSchedule(from: schedule)

        /// 旧バージョンのスケジュールの開始時刻と終了時刻を上書きする
        if let schedule = realm.objects(RealmCoopSchedule.self).first(where: {
            $0.stageId == result.stageId &&
            Array($0.weaponList) == Array(result.weaponList) &&
            $0.rule == result.rule &&
            $0.mode == result.mode &&
            $0.startTime == nil &&
            $0.endTime == nil
        }) {
            if realm.isInWriteTransaction {
                schedule.startTime = result.startTime
                schedule.endTime = result.endTime
            } else {
                try? realm.write {
                    schedule.startTime = result.startTime
                    schedule.endTime = result.endTime
                }
            }
        }

        /// 書き込もうとしているスケジュールと同じものがなければ書き込む
        guard let _ = realm.objects(RealmCoopSchedule.self).firstIndex(of: result) else {
            save(result)
            return
        }
    }

    /// リザルト一件書き込み
    func save(_ result: SplatNet2.Result) {
        /// スケジュールを生成
        let target: RealmCoopSchedule = RealmCoopSchedule(from: result)
        /// リザルト作成
        let object: RealmCoopResult = RealmCoopResult(from: result)

        /// 書き込むべきスケジュール
        guard let schedule: RealmCoopSchedule = realm.objects(RealmCoopSchedule.self).first(where: { $0 == target }) else {
            /// ないということはプライベートバイトなのでスケジュールとリザルトを書き込む
            if realm.isInWriteTransaction {
                realm.add(target)
                target.results.append(object)
            } else {
                realm.beginWrite()
                realm.add(target)
                target.results.append(object)
                try? realm.commitWrite()
            }
            return
        }

        /// リザルト存在チェック
        /// Listへのappendではプライマリーキー制約が判定されない
        /// プライマリーキーが重複していれば既に保存されているので書き込まなくて良い
        guard let _ = realm.object(ofType: RealmCoopResult.self, forPrimaryKey: result.id) else {
            // リザルト書き込み
            if realm.isInWriteTransaction {
                schedule.results.append(object)
            } else {
                realm.beginWrite()
                schedule.results.append(object)
                try? realm.commitWrite()
            }
            return
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
