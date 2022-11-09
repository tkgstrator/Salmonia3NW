//
//  RealmCoopResult.swift
//  Salmonia3+
//
//  Created by tkgstrator on 2022/09/16.
//

import Foundation
import RealmSwift
import SplatNet3

final class RealmCoopResult: Object, Identifiable {
    /// 固有ID
    @Persisted(primaryKey: true) var id: String
    /// Salmon Stats用のID
    @Persisted var salmonId: Int?
    /// 評価レート
    @Persisted var gradePoint: Int?
    /// 評価
    @Persisted var grade: GradeType?
    /// クリアしたかどうか
    @Persisted var isClear: Bool
    /// 失敗したWAVE
    @Persisted var failureWave: Int?
    /// オカシラシャケをたおしたかどうか
    @Persisted var isBossDefeated: Bool?
    /// 獲得イクラ数
    @Persisted var ikuraNum: Int
    /// 合計納品金イクラ数
    @Persisted var goldenIkuraNum: Int
    /// 合計アシスト金イクラ数
    @Persisted var goldenIkuraAssistNum: Int
    /// オオモノ出現数
    @Persisted var bossCounts: List<Int>
    /// オオモノ討伐数
    @Persisted var bossKillCounts: List<Int>
    /// キケン度
    @Persisted var dangerRate: Double
    /// バイトレート
    @Persisted var jobRate: Double?
    /// バイトスコア
    @Persisted var jobScore: Int?
    /// クマサンポイント
    @Persisted var kumaPoint: Int?
    /// バイトボーナス
    @Persisted var jobBonus: Int?
    /// バイトボーナス
    @Persisted var smellMeter: Int?
    /// WAVE内容
    @Persisted var waves: List<RealmCoopWave>
    /// プレイヤー
    @Persisted var players: List<RealmCoopPlayer>
    /// ウロコ枚数
    @Persisted var scale: List<Int?>
    /// 遊んだ時間
    @Persisted var playTime: Date
    /// シナリオコード(将来的に利用される)
    @Persisted var scenarioCode: String?
    /// スケジュールへのバックリンク
    @Persisted(originProperty: "results") private var link: LinkingObjects<RealmCoopSchedule>

    convenience init(from result: SplatNet2.Result) {
        self.init()
        self.id = result.id
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
        self.playTime = Date()
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
        let usages: [(SpecialType, [Int])] = Array(zip(players.compactMap({ $0.specialId }), players.map({ Array($0.specialCounts) })))
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
}
