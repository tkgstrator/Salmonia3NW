//
//  RealmService.swift
//  Salmonia3+
//  
//  Created by devonly on 2022/11/27
//  Copyright © 2022 Magi Corporation. All rights reserved.
//

import Foundation
import RealmSwift
import SwiftUI
import SplatNet3
import ZIPFoundation
import UniformTypeIdentifiers

public class RealmService: ObservableObject {
    public static let shared: RealmService = RealmService()
    private var realm: Realm {
        try! Realm(configuration: RealmMigration.configuration)
    }

    public enum RealmDeleteType: Int, CaseIterable {
        case ALL
        case SCHEDULE
        case RESULT
    }

    func results(player: RealmCoopPlayer) -> RealmSwift.Results<RealmCoopSchedule> {
        realm.objects(RealmCoopSchedule.self).filter("ANY players = %@", player)
    }

    public func deleteAll(options: [RealmDeleteType] = [.ALL]) {
        realm.beginWrite()
        for option in options {
            switch option {
            case .ALL:
                realm.deleteAll()
            case .RESULT:
                realm.delete(realm.objects(RealmCoopResult.self))
            case .SCHEDULE:
                realm.delete(realm.objects(RealmCoopSchedule.self).filter("startTime!=nil"))
            }
        }
        try? realm.commitWrite()
    }

    func exportData() throws -> [CoopResult] {
        try realm.objects(RealmCoopResult.self).filter("salmonId=nil").map({ try $0.asCoopResult() })
    }

    public func updateSalmonId(results: [CoopStatsResultsQuery.Response]) throws {
        try inWriteTransaction(transaction: {
            results.forEach({ result in
                if let object = realm.object(ofType: RealmCoopResult.self, forPrimaryKey: result.id) {
                    object.salmonId = result.salmonId
                }
            })
        })
    }

    public func exportJSON(compress: Bool = true) throws -> URL {
        let fileManager: FileManager = FileManager.default
        let encoder: JSONEncoder = {
            let encoder: JSONEncoder = JSONEncoder()
            encoder.keyEncodingStrategy = .convertToSnakeCase
            encoder.dateEncodingStrategy = .iso8601
            return encoder
        }()
        
        let data: Data = try Signer.sign(schedules: realm.objects(RealmCoopSchedule.self))

        
        let fileName: String = {
            let formatter: DateFormatter = DateFormatter()
            formatter.dateFormat = "yyyyMMddHHmmss"
            return formatter.string(from: Date())
        }()
        guard let baseURL: URL = fileManager.urls(for: .cachesDirectory, in: .userDomainMask).first else {
            throw SPError.invalidURL
        }
        let source: URL = baseURL.appendingPathComponent(fileName).appendingPathExtension("json")
        try data.write(to: source, options: .atomic)

        switch compress {
        case true:
            /// 圧縮設定のときはZIPを返す
            let destination: URL = baseURL.appendingPathComponent(fileName).appendingPathExtension("zip")
            try fileManager.zipItem(at: source, to: destination, compressionMethod: .deflate)
            return destination
        case false:
            /// 非圧縮のときはJSONを返す
            return source
        }
    }

    public func resultsCount() -> Int {
        return realm.objects(RealmCoopResult.self).count
    }

    public func lastPlayedTime() -> Date? {
        return realm.objects(RealmCoopResult.self).max(ofProperty: "playTime")
    }

    /// ファイルからリストア
    public func openURL(url sourceURL: URL, format: FormatType) throws -> Int {
        let decoder: SPDecoder = SPDecoder()

        let data: Data = try {
            switch UTType(filenameExtension: sourceURL.pathExtension) {
            case .some(let ext):
                switch ext {
                case .json:
                    return try Data(contentsOf: sourceURL)
                case .zip:
                    let fileName: String = sourceURL.deletingPathExtension().lastPathComponent
                    let destinationURL: URL = FileManager.default.temporaryDirectory
                    try FileManager.default.createDirectory(at: destinationURL, withIntermediateDirectories: true, attributes: nil)

                    do {
                        try FileManager.default.unzipItem(at: sourceURL, to: destinationURL)
                        return try Data(contentsOf: destinationURL.appendingPathComponent(fileName, conformingTo: .json))
                    } catch {
                        return try Data(contentsOf: destinationURL.appendingPathComponent(fileName, conformingTo: .json))
                    }
                default:
                    throw SPError.invalidExtension
                }
            case .none:
                throw SPError.invalidExtension
            }
        }()
        /// データの変換
        let schedules: [RealmCoopSchedule] = try {
            switch format {
            case .SPLATNET3:
                let results: [CoopHistoryDetailQuery.Response] = (try decoder.decode([CoopHistoryDetailQuery.Response].self, from: data)).filter({ $0.data.coopHistoryDetail.afterGrade != nil })
                return []
            case .SALMONIA3:
                if !Signer.isValid(data: data) {
                    throw SPError.invalidSignature
                }
                return try decoder.decode(SignedRealmCoopResult.self, from: data).schedules
            }
        }()

        /// 追記する
        try inWriteTransaction(transaction: {
            realm.add(schedules, update: .all)
        })

        return schedules.flatMap({ $0.results }).count
    }

    /// リザルト取得APIで取得したスケジュール書き込み
    private func save(_ results: [TransResult]) {
        try? inWriteTransaction(transaction: {
            for result in results {
                let schedule: CoopResult.Schedule = result.schedule
                let results: [RealmCoopResult] = result.results.map({ RealmCoopResult(content: $0) })
                /// 通常のバイト
                if let startTime = schedule.startTime, let endTime = schedule.endTime {
                    /// 本来は何もしなくてよいのだが、イカ研究所がスケジュールを変更した際にこの機能が必要になるため
                    if let result = realm.objects(RealmCoopSchedule.self).filter("startTime=%@ AND endTime=%@", startTime, endTime).first {
                        /// 重複するスケジュールがあればリザルト以外を更新する
                        result.stageId = schedule.stageId
                        result.mode = schedule.mode
                        result.rule = schedule.rule
                        result.weaponList.removeAll()
                        result.weaponList.append(objectsIn: schedule.weaponList)
                        /// リザルトを追加
                        result.results.append(objectsIn: results)
                    } else {
                        /// なければスケジュールを追加する
                        let schedule: RealmCoopSchedule = RealmCoopSchedule(content: schedule)
                        schedule.results.append(objectsIn: results)
                        realm.add(schedule, update: .all)
                    }
                } else {
                    /// プライベートバイト
                    let schedule: RealmCoopSchedule = RealmCoopSchedule(content: schedule)
                    /// プライベートバイトスケジュールが存在しないときだけ追加し、存在するなら何もしない
                    /// ルール、モード、ステージ、ブキが同じなら同じシフトとして扱う
                    if let result = realm.objects(RealmCoopSchedule.self).first(where: {
                        $0.rule == schedule.rule &&
                        $0.mode == schedule.mode &&
                        $0.weaponList == schedule.weaponList &&
                        $0.stageId == schedule.stageId
                    }) {
                        result.results.append(objectsIn: results)
                    } else {
                        /// なければスケジュールを追加する
                        schedule.results.append(objectsIn: results)
                        realm.add(schedule, update: .all)
                    }
                }
            }
        })
    }

    /// スケジュール取得APIで取得したスケジュール書き込み
    public func save(_ schedules: [CoopSchedule]) {
        try? inWriteTransaction(transaction: {
            for schedule in schedules {
                /// 重複するスケジュールがあればリザルト以外を更新する
                if let result = realm.objects(RealmCoopSchedule.self).filter("startTime=%@ AND endTime=%@", schedule.startTime, schedule.endTime).first {
                    result.stageId = schedule.stageId
                    result.mode = schedule.mode
                    result.rule = schedule.rule
                    result.weaponList.removeAll()
                    result.weaponList.append(objectsIn: schedule.weaponList)
                } else {
                    /// なければスケジュール自体を追加する
                    realm.add(RealmCoopSchedule(content: schedule), update: .modified)
                }
            }
        })
    }

    /// スケジュール一括取得APIで取得したスケジュール書き込み
    public func update(_ schedules: [CoopSchedule]) {
        try? inWriteTransaction(transaction: {
            let schedules: [RealmCoopSchedule] = schedules.map({ RealmCoopSchedule(content: $0) })
            /// レギュラーのスケジュールはバグの可能性があるので一旦削除
            realm.delete(realm.objects(RealmCoopSchedule.self).filter("mode=%@", ModeType.REGULAR.rawValue))
            for schedule in schedules {
                if let startTime: Date = schedule.startTime, let endTime: Date = schedule.endTime {
                    /// 該当するリザルトを取得
                    let results: RealmSwift.Results<RealmCoopResult> = realm.objects(RealmCoopResult.self).filter("gradePoint!=nil AND playTime>=%@ AND playTime<=%@", startTime, endTime)
                    /// スケジュールのリザルトに追加
                    schedule.results.append(objectsIn: results)
                }
                /// スケジュールを書き込み
                realm.add(schedule, update: .all)
            }
        })
    }

    /// リザルト書き込み
    public func save(_ results: [CoopResult]) {
        autoreleasepool(invoking: {
            try? inWriteTransaction(transaction: {
                /// スケジュール->リザルトの関係に変換する
                let schedules: Set<CoopResult.Schedule> = Set(results.map({ $0.schedule }))
                let results: [TransResult] = schedules.map({ schedule -> TransResult in
                    TransResult(schedule: schedule, results: results.filter({ $0.schedule == schedule }))
                })
                self.save(results)
            })
        })
    }

    private func inWriteTransaction(transaction writeBlock: () throws -> Void) throws {
        if realm.isInWriteTransaction {
            try writeBlock()
        } else {
            realm.beginWrite()
            try writeBlock()
            try realm.commitWrite()
        }
    }

    private struct TransResult {
        let schedule: CoopResult.Schedule
        let results: [CoopResult]
    }
}
