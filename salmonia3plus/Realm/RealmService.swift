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
        realm.delete(realm.objects(RealmCoopSchedule.self).filter("startTime!=nil"))
        for schedule in schedules {
            /// 必要かどうかはわからない
            schedule.results.removeAll()
            if let startTime: Date = schedule.startTime, let endTime: Date = schedule.endTime {
                let results: RealmSwift.Results<RealmCoopResult> = realm.objects(RealmCoopResult.self).filter("jobRate!=nil AND playTime<=%@ AND playTime<=%@", startTime, endTime)
                schedule.results.append(objectsIn: results)
            }
            realm.add(schedules, update: .all)
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

    public func exportJSON() throws -> URL {
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
        guard let dir: URL = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first else {
            throw DecodingError.dataCorrupted(.init(codingPath: [], debugDescription: "Invalid URL"))
        }
        let filePath: URL = dir.appendingPathComponent(fileName).appendingPathExtension("json")
        try data.write(to: filePath, options: .atomic)
        return filePath
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
        let schedules: Set<CoopResult.Schedule> = Set(results.map({ $0.schedule }))

        schedules.forEach({ schedule in
            let results: [RealmCoopResult] = results.filter({ $0.schedule == schedule }).map({ RealmCoopResult(content: $0) })
            let schedule: RealmCoopSchedule = RealmCoopSchedule(content: schedule)
            realm.beginWrite()
            // 存在しなかったら書き込む
            if !realm.objects(RealmCoopSchedule.self).contains(schedule) {
                realm.add(schedule)
                schedule.results.append(objectsIn: results)
            }
            try? realm.commitWrite()
        })
    }
}
