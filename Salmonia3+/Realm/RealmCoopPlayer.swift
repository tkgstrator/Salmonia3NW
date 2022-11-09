//
//  RealmCoopPlayer.swift
//  Salmonia3+
//
//  Created by tkgstrator on 2022/09/16.
//

import Foundation
import RealmSwift
import SplatNet3

final class RealmCoopPlayer: Object, Identifiable {
    @Persisted(primaryKey: true) var id: String
    @Persisted(indexed: true) var pid: String
    @Persisted var name: String
    @Persisted var byname: String
    @Persisted var nameId: String
    @Persisted var isMyself: Bool
    @Persisted var deadCount: Int
    @Persisted var helpCount: Int
    @Persisted var goldenIkuraNum: Int
    @Persisted var ikuraNum: Int
    @Persisted var goldenIkuraAssistNum: Int
    @Persisted var specialId: SpecialType?
    @Persisted var species: SpeciesType
    @Persisted var bossKillCountsTotal: Int
    @Persisted var bossKillCounts: List<Int>
    @Persisted var specialCounts: List<Int>
    @Persisted var badges: List<BadgeType?>
    @Persisted var background: NamePlateType
    @Persisted var weaponList: List<WeaponType>
    @Persisted(originProperty: "players") private var link: LinkingObjects<RealmCoopResult>

    convenience init(from result: SplatNet2.PlayerResult) {
        self.init()
        self.id = result.id
        self.byname = result.byname
        self.nameId = result.nameId
        self.isMyself = result.isMyself
        self.pid = result.id.capture(pattern: #"u-(\w*)$"#, group: 1)!
        self.name = result.name
        self.goldenIkuraNum = result.goldenIkuraNum
        self.ikuraNum = result.ikuraNum
        self.deadCount = result.deadCount
        self.helpCount = result.helpCount
        self.goldenIkuraAssistNum = result.goldenIkuraAssistNum
        self.specialId = result.special
        self.species = result.species
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
        self.name = "とてもなまえがながい"
        self.goldenIkuraNum = 999
        self.ikuraNum = 9999
        self.deadCount = 99
        self.helpCount = 99
        self.goldenIkuraAssistNum = 99
        self.specialId = SpecialType.SpUltraShot
        self.species = SpeciesType.INKLING
        self.specialCounts.append(objectsIn: Array(repeating: 1, count: 3))
        self.weaponList.append(objectsIn: Array(repeating: WeaponType.Saber_Normal, count: 4))
        self.bossKillCounts.append(objectsIn: Array(repeating: 99, count: 15))
        self.bossKillCountsTotal = 99
        self.background = NamePlateType.Npl_Tutorial00
        self.badges.append(objectsIn: Array(repeating: nil, count: 3))
    }
}

extension BadgeType: PersistableEnum {}

extension NamePlateType: PersistableEnum {}

extension SpeciesType: PersistableEnum {}

extension SpecialType: PersistableEnum, RawRepresentable {
    public init?(rawValue: Int) {
        self.init(id: rawValue)
    }
}

extension WeaponType: PersistableEnum, RawRepresentable {
    public init?(rawValue: Int) {
        self.init(id: rawValue)
    }
}

extension StageType: PersistableEnum, RawRepresentable {
    public init?(rawValue: Int) {
        self.init(id: rawValue)
    }
}
