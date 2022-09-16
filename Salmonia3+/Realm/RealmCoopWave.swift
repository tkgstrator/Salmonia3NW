//
//  RealmCoopWave.swift
//  Salmonia3+
//
//  Created by devonly on 2022/09/16.
//

import Foundation
import RealmSwift
import SplatNet3

final class RealmCoopWave: Object, Identifiable {
    @Persisted var id: Int
    @Persisted var waterLevel: Int
    @Persisted var eventType: Int
    @Persisted var goldenIkuraNum: Int?
    @Persisted var quotaNum: Int?
    @Persisted var goldenIkuraPopNum: Int

    convenience init(from result: SplatNet2.WaveResult) {
        self.init()
        self.id = result.id
        self.waterLevel = result.waterLevel.id ?? 1
        self.eventType = result.eventType.id ?? 0
        self.goldenIkuraNum = result.goldenIkuraNum
        self.goldenIkuraPopNum = result.goldenIkuraPopNum
        self.quotaNum = result.quotaNum
    }
}

