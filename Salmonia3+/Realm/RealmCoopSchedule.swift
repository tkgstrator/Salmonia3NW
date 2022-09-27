//
//  RealmCoopSchedule.swift
//  Salmonia3+
//
//  Created by devonly on 2022/09/16.
//

import Foundation
import RealmSwift
import SplatNet3

class RealmCoopSchedule: Object, Identifiable {
    @Persisted(primaryKey: true) var id: Int
    @Persisted var stageId: StageType
    @Persisted var startTime: Date?
    @Persisted var endTime: Date?
    @Persisted var weaponList: List<WeaponType>
    @Persisted var results: List<RealmCoopResult>
    @Persisted var rareWeapon: Int?
    @Persisted var rule: SplatNet2.Rule

    convenience init(from result: SplatNet2.Result) {
        self.init()
        self.stageId = result.schedule.stage
        self.weaponList.append(objectsIn: result.schedule.weaponLists)
        self.rule = result.rule
        self.rareWeapon = nil
        self.id = weaponList.hash &+ stageId.hashValue &+ rule.hashValue
    }

    convenience init(dummy: Bool = true) {
        self.init()
        self.stageId = StageType.Shakespiral
        self.weaponList.append(objectsIn: Array(repeating: WeaponType.Saber_Normal, count: 4))
        self.rule = SplatNet2.Rule.REGULAR
        self.rareWeapon = nil
        self.id = 0
    }
}
