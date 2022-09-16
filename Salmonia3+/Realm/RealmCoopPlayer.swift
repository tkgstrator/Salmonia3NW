//
//  RealmCoopPlayer.swift
//  Salmonia3+
//
//  Created by devonly on 2022/09/16.
//

import Foundation
import RealmSwift
import SplatNet3

final class RealmCoopPlayer: Object, Identifiable {
    @Persisted(primaryKey: true) var id: String
    @Persisted(indexed: true) var pid: String
    @Persisted var name: String
    @Persisted var deadCount: Int
    @Persisted var helpCount: Int
    @Persisted var goldenIkuraNum: Int
    @Persisted var ikuraNum: Int
    @Persisted var goldenIkuraAssistNum: Int
    @Persisted var specialId: SpecialType
    @Persisted var bossKillCounts: List<Int>
    @Persisted var specialCounts: List<Int>
    @Persisted var weaponList: List<WeaponType>

    convenience init(from result: SplatNet2.PlayerResult) {
        self.init()
        self.id = result.id
        self.pid = result.id.capture(pattern: #"u-(\w*)$"#, group: 1)!
        self.name = result.name
        self.goldenIkuraNum = result.goldenIkuraNum
        self.ikuraNum = result.ikuraNum
        self.deadCount = result.deadCount
        self.helpCount = result.helpCount
        self.goldenIkuraAssistNum = result.goldenIkuraAssistNum
        self.specialId = result.special
        self.specialCounts.append(objectsIn: result.specialCounts)
        self.weaponList.append(objectsIn: result.weaponList)
        self.bossKillCounts.append(objectsIn: result.bossKillCounts)
    }
}

extension SpecialType: PersistableEnum, RawRepresentable {
    public init?(rawValue: Int) {
        self.init(id: rawValue)
    }

    public var rawValue: Int { self.id! }
}

extension WeaponType: PersistableEnum, RawRepresentable {
    public init?(rawValue: Int) {
        self.init(id: rawValue)
    }

    public var rawValue: Int { self.id! }
}

extension StageType: PersistableEnum, RawRepresentable {
    public init?(rawValue: Int) {
        self.init(id: rawValue)
    }

    public var rawValue: Int { self.id! }
}
