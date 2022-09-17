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
    @Persisted var grade: GradeType?
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
        self.grade = result.grade
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
        self.gradePoint = 400
        self.grade = GradeType.Eggsecutive_VP
        self.failureWave = nil
        self.isClear = true
        self.isBossDefeated = true
        self.ikuraNum = 9999
        self.goldenIkuraNum = 999
        self.goldenIkuraAssistNum = 999
        self.dangerRate = 3.33
        self.jobRate = 9.99
        self.jobScore = 999
        self.kumaPoint = 9999
        self.jobBonus = 999
        self.scale.append(objectsIn: [99, 99, 99])
        self.bossCounts.append(objectsIn: Array(repeating: 99, count: 15))
        self.bossKillCounts.append(objectsIn: Array(repeating: 99, count: 15))
        self.waves.append(objectsIn: [0, 1, 2, 3].map({ RealmCoopWave(dummy: true, id: $0) }) )
        self.players.append(objectsIn: [0, 1, 2, 3].map({ RealmCoopPlayer(dummy: true, id: $0) }))
    }
}

extension RealmCoopResult {
    var schedule: RealmCoopSchedule {
        self.link.first ?? RealmCoopSchedule(dummy: true)
    }

    var specialUsage: [[SpecialType]] {
        let usages: [(SpecialType, [Int])] = Array(zip(players.map({ $0.specialId }), players.map({ Array($0.specialCounts) })))
        var specialUsage: [[SpecialType]] = Array(repeating: [], count: waves.count)

        for usage in usages {
            for (index, count) in usage.1.enumerated() {
                specialUsage[index].append(contentsOf: Array(repeating: usage.0, count: count))
            }
        }
        return specialUsage.map({ $0.sorted(by: { $0.rawValue < $1.rawValue })})
    }
}

extension GradeType: RawRepresentable, PersistableEnum {
    public init?(rawValue: Int) {
        self.init(id: rawValue)
    }

    public var rawValue: Int { self.id! }
}

extension SplatNet2.Rule: PersistableEnum {}
