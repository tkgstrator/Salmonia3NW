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

    convenience init(dummy: Bool = true, id: Int = 0, eventType: EventType = EventType.Water_Levels, waterLevel: WaterType = WaterType.Middle_Tide) {
        self.init()
        self.id = id
        self.waterLevel = waterLevel
        self.eventType = eventType
        self.goldenIkuraNum = 999
        self.goldenIkuraPopNum = 999
        self.quotaNum = 35
    }
}

extension RealmCoopWave {
    /// リザルト
    private var result: RealmCoopResult? {
        self.link.first
    }

    /// クリアしたWAVEかどうか
    var isClearWave: Bool {
        /// リザルトが存在する
        if let result = result {
            // ミスしていたらWAVEのIDと同じならFalse、違うならTrue
            if let failureWave: Int = result.failureWave {
                return failureWave != self.id
            }
            // ミスしてなかったら常にTrue
            return true
        }
        return true
    }

    /// そのWAVEで使ったスペシャルの配列
    var specialUsage: [SpecialType] {
        if let result = result {
            return result.specialUsage[self.id - 1]
        }
        return []
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

