//
//  StatsService.swift
//  Salmonia3+
//
//  Created by devonly on 2022/10/08.
//

import Foundation
import RealmSwift
import SplatNet3

struct Stats {
    /// 和
    let summation: Int?
    /// 最大値
    let maximum: Int?
    /// 最小値
    let minimum: Int?
    /// 平均値
    let average: Double?
}

struct WaveStats {
    /// 出現回数
    let count: Int
    /// イクラ統計
    let ikuraStats: Stats
    /// 金イクラ統計
    let goldenIkuraStats: Stats
    /// アシスト統計
    let assistIkuraStats: Stats
}

final class StatsService: ObservableObject {
    /// バイト回数
    @Published var shiftsWorked: Int
    /// WAVE回数
    @Published var waveCounts: Int
    /// クリア率
    @Published var clearRatio: Double
    /// 平均クリアWAVE
    @Published var clearWave: Double
    /// オカシラシャケ討伐率
    @Published var bossDefeatedRatio: Double
    /// 各スペシャル支給回数
    @Published var specialCounts: [Int]
    /// 支給ブキ
    @Published var weaponList: [WeaponType]
    /// 各ブキ支給回数
    @Published var weaponCounts: [Int]
    /// 各WAVE失敗回数
    @Published var failureWaveCount: [Int]
    /// オカシラシャケ出現数
    @Published var bossCount: Int
    /// オカシラシャケ討伐数
    @Published var bossKillCount: Int
    /// チームイクラ統計
    @Published var teamIkuraStats: Stats
    /// チーム金イクラ統計
    @Published var teamGoldenIkuraStats: Stats
    /// イクラ統計
    @Published var ikuraStats: Stats
    /// 金イクラ統計
    @Published var goldenIkuraStats: Stats
    /// 金イクラアシスト統計
    @Published var assistIkuraStats: Stats
    /// 救助数
    @Published var helpStats: Stats
    /// 被救助数
    @Published var deathStats: Stats
    /// オオモノ討伐数
    @Published var defeatedStats: Stats
    /// 各WAVEの統計
    @Published var waves: [[WaveStats]]
    /// 最高評価レート
    @Published var maxGradePoint: Int?
    /// 評価レートの履歴
    @Published var gradePointHistory: [Double]

    init(startTime: Date) {
        let results: RealmSwift.List<RealmCoopResult> = {
            if let results = RealmService.shared.objects(ofType: RealmCoopSchedule.self).first(where: { $0.startTime == startTime })?.results {
                return results
            }
            return RealmSwift.List<RealmCoopResult>()
        }()
        let players: RealmSwift.Results<RealmCoopPlayer> = RealmService.shared.objects(ofType: RealmCoopPlayer.self).filter("ANY link.link.startTime=%@ AND isMyself=true", startTime)
        let weaponList: [WeaponType] = {
            if let schedule = RealmService.shared.objects(ofType: RealmCoopSchedule.self).first(where: { $0.startTime == startTime }) {
                return Array(schedule.weaponList)
            }
            return []
        }()

        self.shiftsWorked = results.count
        self.waveCounts = 0
        self.clearRatio = 0
        self.clearWave = 0
        self.bossDefeatedRatio = 0
        self.bossCount = 0
        self.bossKillCount = 0
        self.specialCounts = {
            // 支給されたスペシャル一覧
            let suppliedSpecialList: [SpecialType] = players.compactMap({ $0.specialId })
            return SpecialType.allCases.dropFirst().map({ id in suppliedSpecialList.filter({ $0 == id }).count })
        }()
        self.weaponList = weaponList
        self.weaponCounts = {
            // 支給されたブキ一覧
            let suppliedWeaponList: [WeaponType] = players.flatMap({ $0.weaponList })
            print(suppliedWeaponList, Set(suppliedWeaponList))
            return weaponList.map({ id in suppliedWeaponList.filter({ $0 == id }).count })
        }()
        self.failureWaveCount = Array(repeating: 0, count: 4)
        self.teamIkuraStats = {
            let summation: Int? = results.sum(ofProperty: "ikuraNum")
            let maximum: Int? = results.max(ofProperty: "ikuraNum")
            let minimum: Int? = results.min(ofProperty: "ikuraNum")
            let average: Double? = results.average(ofProperty: "ikuraNum")
            return Stats(summation: summation, maximum: maximum, minimum: minimum, average: average)
        }()
        self.teamGoldenIkuraStats = {
            let summation: Int? = results.sum(ofProperty: "goldenIkuraNum")
            let maximum: Int? = results.max(ofProperty: "goldenIkuraNum")
            let minimum: Int? = results.min(ofProperty: "goldenIkuraNum")
            let average: Double? = results.average(ofProperty: "goldenIkuraNum")
            return Stats(summation: summation, maximum: maximum, minimum: minimum, average: average)
        }()
        self.assistIkuraStats = {
            let summation: Int? = results.sum(ofProperty: "goldenIkuraAssistNum")
            let maximum: Int? = results.max(ofProperty: "goldenIkuraAssistNum")
            let minimum: Int? = results.min(ofProperty: "goldenIkuraAssistNum")
            let average: Double? = results.average(ofProperty: "goldenIkuraAssistNum")
            return Stats(summation: summation, maximum: maximum, minimum: minimum, average: average)
        }()
        self.ikuraStats = {
            let summation: Int? = players.sum(ofProperty: "ikuraNum")
            let maximum: Int? = players.max(ofProperty: "ikuraNum")
            let minimum: Int? = players.min(ofProperty: "ikuraNum")
            let average: Double? = players.average(ofProperty: "ikuraNum")
            return Stats(summation: summation, maximum: maximum, minimum: minimum, average: average)
        }()
        self.goldenIkuraStats = {
            let summation: Int? = players.sum(ofProperty: "goldenIkuraNum")
            let maximum: Int? = players.max(ofProperty: "goldenIkuraNum")
            let minimum: Int? = players.min(ofProperty: "goldenIkuraNum")
            let average: Double? = players.average(ofProperty: "goldenIkuraNum")
            return Stats(summation: summation, maximum: maximum, minimum: minimum, average: average)
        }()
        self.helpStats = {
            let summation: Int? = players.sum(ofProperty: "helpCount")
            let maximum: Int? = players.max(ofProperty: "helpCount")
            let minimum: Int? = players.min(ofProperty: "helpCount")
            let average: Double? = players.average(ofProperty: "helpCount")
            return Stats(summation: summation, maximum: maximum, minimum: minimum, average: average)
        }()
        self.deathStats = {
            let summation: Int? = players.sum(ofProperty: "deadCount")
            let maximum: Int? = players.max(ofProperty: "deadCount")
            let minimum: Int? = players.min(ofProperty: "deadCount")
            let average: Double? = players.average(ofProperty: "deadCount")
            return Stats(summation: summation, maximum: maximum, minimum: minimum, average: average)
        }()
        self.defeatedStats = {
            let summation: Int? = players.sum(ofProperty: "bossKillCountsTotal")
            let maximum: Int? = players.max(ofProperty: "bossKillCountsTotal")
            let minimum: Int? = players.min(ofProperty: "bossKillCountsTotal")
            let average: Double? = players.average(ofProperty: "bossKillCountsTotal")
            return Stats(summation: summation, maximum: maximum, minimum: minimum, average: average)
        }()
        let stats: Stats = Stats(summation: 0, maximum: 0, minimum: 0, average: 0)
        self.waves = Array(repeating: Array(repeating: WaveStats(count: 0, ikuraStats: stats, goldenIkuraStats: stats, assistIkuraStats: stats), count: 9), count: 3)
        self.maxGradePoint = results.max(ofProperty: "gradePoint")
        self.gradePointHistory = results.compactMap({ $0.gradePoint }).map({ Double($0) })
        print(self.weaponCounts)
    }
}
