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
    @Persisted var specialId: SpecialType?
    @Persisted var bossKillCountsTotal: Int
    @Persisted var bossKillCounts: List<Int>
    @Persisted var specialCounts: List<Int>
    @Persisted var badges: List<BadgeType?>
    @Persisted var background: NamePlateType?
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
        self.bossKillCountsTotal = result.bossKillCountsTotal
        self.background = result.nameplate.background.id
        self.badges.append(objectsIn: result.nameplate.badges)
    }

    convenience init(dummy: Bool = true, id: Int = 1) {
        self.init()
        self.id = "\(id)"
        self.pid = "0000000000000000"
        self.name = "Player\(id)"
        self.goldenIkuraNum = 999
        self.ikuraNum = 9999
        self.deadCount = 99
        self.helpCount = 99
        self.goldenIkuraAssistNum = 999
        self.specialId = SpecialType.SpUltraShot
        self.specialCounts.append(objectsIn: Array(repeating: 1, count: 3))
        self.weaponList.append(objectsIn: Array(repeating: WeaponType.Saber_Normal, count: 3))
        self.bossKillCounts.append(objectsIn: Array(repeating: 99, count: 15))
        self.bossKillCountsTotal = 99
    }
}

extension BadgeType: PersistableEnum {}

extension NamePlateType: PersistableEnum {}

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
