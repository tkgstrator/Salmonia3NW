//
//  RealmCoopResult.swift
//  Salmonia3+
//
//  Created by devonly on 2022/09/16.
//

import Foundation
import RealmSwift
import SplatNet3

final class RealmCoopResult: Object, Identifiable {
    @Persisted(primaryKey: true) var id: String
    @Persisted var rule: SplatNet2.Rule?
    @Persisted var salmonId: Int?
    @Persisted var gradePoint: Int?
    @Persisted var grade: Int?
    @Persisted var isClear: Bool
    @Persisted var failureWave: Int?
    @Persisted var isBossDefeated: Bool?
    @Persisted var ikuraNum: Int
    @Persisted var goldenIkuraNum: Int
    @Persisted var goldenIkuraAssistNum: Int
    @Persisted var bossCounts: List<Int>
    @Persisted var bossKillCounts: List<Int>
    @Persisted var dangerRate: Double
    @Persisted var jobRate: Double?
    @Persisted var jobScore: Int?
    @Persisted var kumaPoint: Int?
    @Persisted var jobBonus: Int?
    @Persisted var waves: List<RealmCoopWave>
    @Persisted var players: List<RealmCoopPlayer>

    convenience init(from result: SplatNet2.Result) {
        self.init()
        self.id = result.id
        self.rule = result.rule
        self.gradePoint = result.gradePoint
        self.grade = result.grade?.id
        self.failureWave = result.jobResult.failureWave
        self.isClear = result.jobResult.isClear
        self.isBossDefeated = result.jobResult.isBossDefeated
        self.ikuraNum = result.ikuraNum
        self.goldenIkuraNum = result.goldenIkuraNum
        self.goldenIkuraAssistNum = result.goldenIkuraAssistNum
        self.bossCounts.append(objectsIn: result.bossCounts)
        self.bossKillCounts.append(objectsIn: result.bossKillCounts)
        self.dangerRate = result.dangerRate
        self.jobRate = result.jobRate
        self.jobScore = result.jobScore
        self.kumaPoint = result.kumaPoint
        self.jobBonus = result.jobBonus

        let players: [SplatNet2.PlayerResult] = [result.myResult] + result.otherResults
        self.waves.append(objectsIn: result.waveDetails.map({ RealmCoopWave(from: $0) }))
        self.players.append(objectsIn: players.map({ RealmCoopPlayer(from: $0) }))
    }
}


extension SplatNet2.Rule: PersistableEnum {}
