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
    @Persisted(indexed: true) var rule: SplatNet2.Rule?
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
    @Persisted var smellMeter: Int?
    @Persisted var waves: List<RealmCoopWave>
    @Persisted var players: List<RealmCoopPlayer>
    @Persisted var scale: List<Int?>
    @Persisted var playTime: Date
    #warning("これでちゃんとバックリンクできてたっけ")
    @Persisted(originProperty: "results") private var link: LinkingObjects<RealmCoopSchedule>

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
        self.dangerRate = result.dangerRate
        self.jobRate = result.jobRate
        self.jobScore = result.jobScore
        self.kumaPoint = result.kumaPoint
        self.jobBonus = result.jobBonus
        self.bossCounts.append(objectsIn: result.bossCounts)
        self.bossKillCounts.append(objectsIn: result.bossKillCounts)
        self.scale.append(objectsIn: result.scale)
        self.playTime = Date(timeIntervalSince1970: TimeInterval(result.playTime))
        self.smellMeter = result.smellMeter

        let players: [SplatNet2.PlayerResult] = [result.myResult] + result.otherResults
        self.waves.append(objectsIn: result.waveDetails.map({ RealmCoopWave(from: $0) }))
        self.players.append(objectsIn: players.map({ RealmCoopPlayer(from: $0) }))
    }

    convenience init(dummy: Bool = true) {
        self.init()
        self.id = "00000000000000000000000000000000"
        self.rule = .REGULAR
        self.gradePoint = 999
        self.grade = 8
        self.failureWave = nil
        self.isClear = true
        self.isBossDefeated = true
        self.ikuraNum = 9999
        self.goldenIkuraNum = 999
        self.goldenIkuraAssistNum = 999
        self.dangerRate = 2.0
        self.jobRate = 999
        self.jobScore = 999
        self.kumaPoint = 9999
        self.jobBonus = 999
        self.bossCounts.append(objectsIn: Array(repeating: 99, count: 15))
        self.bossKillCounts.append(objectsIn: Array(repeating: 99, count: 15))
        self.waves.append(objectsIn: Array(repeating: RealmCoopWave(), count: 4))
        self.players.append(objectsIn: Array(repeating: RealmCoopPlayer(), count: 4))
        self.schedule.stageId = StageType.Shakespiral
    }
}

extension RealmCoopResult {
    var schedule: RealmCoopSchedule {
        self.link.first!
    }
}

extension SplatNet2.Rule: PersistableEnum {}
