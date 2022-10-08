//
//  StatsService.swift
//  Salmonia3+
//
//  Created by devonly on 2022/10/08.
//

import Foundation
import RealmSwift

struct Stats {
    /// 和
    let summation: Int
    /// 最大値
    let maximum: Int
    /// 最小値
    let minimum: Int
    /// 平均値
    let avgerage: Double
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
    /// 各ブキ支給回数
    @Published var weaponCounts: [Int]
    /// 各WAVE失敗回数
    @Published var failureWaveCount: [Int]
    /// オカシラシャケ出現数
    @Published var bossCount: Int
    /// オカシラシャケ討伐数
    @Published var bossKillCount: Int
    /// イクラ統計
    @Published var ikuraStats: Stats
    /// 金イクラ統計
    @Published var goldenIkuraStats: Stats
    /// 金イクラアシスト統計
    @Published var assistIkuraStas: Stats
    /// 救助数
    @Published var helpStats: Stats
    /// 被救助数
    @Published var deathStats: Stats
    /// 各WAVEの統計
    @Published var waves: [[WaveStats]]

    init(startTime: Int) {
        self.shiftsWorked = 0
        self.waveCounts = 0
        self.clearRatio = 0
        self.clearWave = 0
        self.bossDefeatedRatio = 0
        self.bossCount = 0
        self.bossKillCount = 0
        self.specialCounts = Array(repeating: 0, count: 7)
        self.weaponCounts = Array(repeating: 0, count: 4)
        self.failureWaveCount = Array(repeating: 0, count: 4)
        self.ikuraStats = Stats(summation: 0, maximum: 0, minimum: 0, avgerage: 0)
        self.goldenIkuraStats = Stats(summation: 0, maximum: 0, minimum: 0, avgerage: 0)
        self.assistIkuraStas = Stats(summation: 0, maximum: 0, minimum: 0, avgerage: 0)
        self.helpStats = Stats(summation: 0, maximum: 0, minimum: 0, avgerage: 0)
        self.deathStats = Stats(summation: 0, maximum: 0, minimum: 0, avgerage: 0)
        let stats: Stats = Stats(summation: 0, maximum: 0, minimum: 0, avgerage: 0)
        self.waves = Array(repeating: Array(repeating: WaveStats(count: 0, ikuraStats: stats, goldenIkuraStats: stats, assistIkuraStats: stats), count: 9), count: 3)
    }
}
