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

public actor RealmService: ObservableObject {
    public static let shared: RealmService = RealmService()
    private var realm: Realm {
        try! Realm(configuration: RealmMigration.configuration)
    }

    public enum RealmDeleteType: Int, CaseIterable {
        case ALL
        case SCHEDULE
        case RESULT
    }

    public func update(_ schedules: [CoopSchedule]) {
        let schedules: [RealmCoopSchedule] = schedules.map({ RealmCoopSchedule(content: $0) })
        /// スケジュール書き込み
        realm.beginWrite()
        /// 必要かどうかはわからない
        realm.delete(realm.objects(RealmCoopSchedule.self).filter("mode=%@", ModeType.REGULAR.rawValue))
        for schedule in schedules {
            /// 必要かどうかはわからない
            schedule.results.removeAll()
            if let startTime: Date = schedule.startTime, let endTime: Date = schedule.endTime {
                let results: RealmSwift.Results<RealmCoopResult> = realm.objects(RealmCoopResult.self).filter("gradePoint!=nil AND playTime>=%@ AND playTime<=%@", startTime, endTime)
                schedule.results.append(objectsIn: results)
            }
            realm.add(schedule, update: .all)
        }
        try? realm.commitWrite()
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

    public func exportJSON(compress: Bool = true) throws -> URL {
        let fileManager: FileManager = FileManager.default
        let encoder: JSONEncoder = {
            let encoder: JSONEncoder = JSONEncoder()
            encoder.keyEncodingStrategy = .convertToSnakeCase
            return encoder
        }()
        let schedules: RealmSwift.Results<RealmCoopSchedule> = realm.objects(RealmCoopSchedule.self)
        let data: Data = try encoder.encode(schedules)
        let fileName: String = {
            let formatter: DateFormatter = DateFormatter()
            formatter.dateFormat = "yyyymmddHHMMss"
            return formatter.string(from: Date())
        }()
        guard let baseURL: URL = fileManager.urls(for: .documentDirectory, in: .userDomainMask).first else {
            throw DecodingError.dataCorrupted(.init(codingPath: [], debugDescription: "Invalid URL"))
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

    public func save(_ schedules: [CoopSchedule]) {
        if realm.isInWriteTransaction {
            let schedules: [RealmCoopSchedule] = schedules.map({ RealmCoopSchedule(content: $0) })
            for schedule in schedules {
                realm.add(schedule, update: .all)
            }
        } else {
            realm.beginWrite()
            let schedules: [RealmCoopSchedule] = schedules.map({ RealmCoopSchedule(content: $0) })
            for schedule in schedules {
                realm.add(schedule, update: .all)
            }
            try? realm.commitWrite()
        }
    }

    public func save(_ results: [CoopResult]) {
        /// スケジュール書き込み
        let schedules: [RealmCoopSchedule] = Set(results.map({ $0.schedule })).map({ RealmCoopSchedule(content: $0) })
        realm.beginWrite()
        realm.add(schedules, update: .modified)
        try? realm.commitWrite()

        /// 書き込むべきリザルト
        let results: [RealmCoopResult] = results.map({ RealmCoopResult(content: $0) })
        print(schedules.count, results.count)
        realm.beginWrite()
        /// リザルト全件書き込み
        realm.add(results, update: .all)
        /// スケジュールに割り当てる
        for schedule in schedules {
            if let schedule = realm.objects(RealmCoopSchedule.self).first(where: { $0 == schedule }),
               let startTime = schedule.startTime,
               let endTime = schedule.endTime
            {
                let results = results.filter({ $0.playTime >= startTime && $0.playTime <= endTime && $0.grade != nil })
                schedule.results.append(objectsIn: results)
            }
        }
        try? realm.commitWrite()
    }
}
