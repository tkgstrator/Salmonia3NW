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
    @Environment(\.realm) var realm

    private init() {}
    public static let shared: RealmService = RealmService()

    public func deleteAll() {
        realm.beginWrite()
        realm.deleteAll()
        try? realm.commitWrite()
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
