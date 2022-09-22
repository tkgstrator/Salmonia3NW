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
    @Persisted(indexed: true) var waterLevel: WaterType
    @Persisted(indexed: true) var eventType: EventType
    @Persisted var goldenIkuraNum: Int?
    @Persisted var quotaNum: Int?
    @Persisted var goldenIkuraPopNum: Int
    @Persisted(originProperty: "waves") private var link: LinkingObjects<RealmCoopResult>

    convenience init(from result: SplatNet2.WaveResult) {
        self.init()
        self.id = result.id
        self.waterLevel = result.waterLevel
        self.eventType = result.eventType
        self.goldenIkuraNum = result.goldenIkuraNum
        self.goldenIkuraPopNum = result.goldenIkuraPopNum
        self.quotaNum = result.quotaNum
    }

    convenience init(dummy: Bool = true, id: Int = 0) {
        self.init()
        self.id = id
        self.waterLevel = WaterType.Middle_Tide
        self.eventType = EventType.Water_Levels
        self.goldenIkuraNum = 999
        self.goldenIkuraPopNum = 999
        self.quotaNum = 35
    }
}

extension RealmCoopWave {
    var result: RealmCoopResult {
        self.link.first!
    }

    var specialUsage: [SpecialType] {
        result.specialUsage[self.id - 1]
    }
}

extension WaterType: RawRepresentable, PersistableEnum {
    public init?(rawValue: Int) {
        self.init(id: rawValue)
    }

    public var rawValue: Int { self.id! }
}

extension EventType: RawRepresentable, PersistableEnum {
    public init?(rawValue: Int) {
        self.init(id: rawValue)
    }

    public var rawValue: Int { self.id! }
}

