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
    @Persisted var id: String
    @Persisted var name: String
    @Persisted var deadCount: Int
    @Persisted var helpCount: Int
    @Persisted var goldenIkuraNum: Int
    @Persisted var ikuraNum: Int
    @Persisted var goldenIkuraAssistNum: Int
    @Persisted var specialId: Int
    @Persisted var bossKillCounts: List<Int>
    @Persisted var specialCounts: List<Int>
    @Persisted var weaponList: List<Int>

    convenience init(from result: SplatNet2.PlayerResult) {
        self.init()
        self.id = result.id
        self.name = result.name
        self.goldenIkuraNum = result.goldenIkuraNum
        self.ikuraNum = result.ikuraNum
        self.deadCount = result.deadCount
        self.helpCount = result.helpCount
        self.goldenIkuraAssistNum = result.goldenIkuraAssistNum
        self.specialId = result.special.id ?? 1
        self.specialCounts.append(objectsIn: result.specialCounts)
        self.weaponList.append(objectsIn: result.weaponList.compactMap({ $0.id }))
        self.bossKillCounts.append(objectsIn: result.bossKillCounts)
    }
}

