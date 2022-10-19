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

enum Grizzco {
    /// SplatNet2形式のデータ
    class AverageData: ObservableObject {
        /// 支給されたブキ
        @Published var weaponList: [WeaponType]
        /// レアブキ
        @Published var rareWeapon: WeaponType?
        /// 平均金イクラ
        @Published var goldenIkuraNum: Double?
        /// 平均イクラ
        @Published var ikuraNum: Double?
        /// 平均救助数
        @Published var helpCount: Double?
        /// 平均被救助数
        @Published var deadCount: Double?

        init(
            weaponList: [WeaponType],
            rareWeapon: WeaponType?,
            ikuraNum: Double?,
            goldenIkuraNum: Double?,
            helpCount: Double?,
            deadCount: Double?
        ) {
            self.weaponList = weaponList
            self.rareWeapon = rareWeapon
            self.ikuraNum = ikuraNum
            self.goldenIkuraNum = goldenIkuraNum
            self.helpCount = helpCount
            self.deadCount = deadCount
        }
    }

    /// クマサンポイントカード
    class PointData: ObservableObject {
        @Published var playCount: Int?
        @Published var goldenIkuraNum: Int?
        @Published var ikuraNum: Int?
        @Published var bossKillCount: Int?
        @Published var regularPoint: Int?
        @Published var regularPointTotal: Int?
        @Published var rescueCount: Int?

        init(
            playCount: Int?,
            ikuraNum: Int?,
            goldenIkuraNum: Int?,
            bossKillCount: Int?,
            regularPoint: Int?,
            regularPointTotal: Int?,
            rescueCount: Int?
        ) {
            self.playCount = playCount
            self.ikuraNum = ikuraNum
            self.goldenIkuraNum = goldenIkuraNum
            self.bossKillCount = bossKillCount
            self.regularPoint = regularPoint
            self.regularPointTotal = regularPointTotal
            self.rescueCount = rescueCount
        }
    }

    /// 最高記録
    class HighData: ObservableObject {
        @Published var maxGrade: GradeType?
        @Published var maxGradePoint: Int?
        @Published var averageWaveCleared: Double?

        init(
            maxGrade: GradeType?,
            maxGradePoint: Int?,
            averageWaveCleared: Double?
        ) {
            self.maxGrade = maxGrade
            self.maxGradePoint = maxGradePoint
            self.averageWaveCleared = averageWaveCleared
        }
    }

    /// ウロコデータ
    class ScaleData: ObservableObject {
        @Published var gold: Int?
        @Published var silver: Int?
        @Published var bronze: Int?

        init(gold: Int?, silver: Int?, bronze: Int?) {
            self.gold = gold
            self.silver = silver
            self.bronze = bronze
        }
    }
}



final class StatsService: ObservableObject {
    /// バイト回数
    @Published var shiftsWorked: Int
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
    @Published var bossCount: [Int]
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
    /// クマサンポイントデータ
    @Published var point: Grizzco.PointData
    /// クマサンカードデータ
    @Published var average: Grizzco.AverageData
    /// クマサンウロコデータ
    @Published var scale: Grizzco.ScaleData
    /// クマサン最高データ
    @Published var maximum: Grizzco.HighData

    init(startTime: Date) {
        /// リザルト一覧
        let results: RealmSwift.List<RealmCoopResult> = {
            if let results = RealmService.shared.objects(ofType: RealmCoopSchedule.self).first(where: { $0.startTime == startTime })?.results {
                return results
            }
            return RealmSwift.List<RealmCoopResult>()
        }()

        /// プレイヤー一覧
        let players: RealmSwift.Results<RealmCoopPlayer> = RealmService.shared.objects(ofType: RealmCoopPlayer.self).filter("ANY link.link.startTime=%@ AND isMyself=true", startTime)

        /// 支給されるブキ一覧
        let weaponList: [WeaponType] = {
            if let schedule = RealmService.shared.objects(ofType: RealmCoopSchedule.self).first(where: { $0.startTime == startTime }) {
                return Array(schedule.weaponList)
            }
            return []
        }()

        /// レアブキ
        let rareWeapon: WeaponType? = {
            /// 支給されたブキの一覧
            let weaponList: Set<WeaponType> = Set(RealmService.shared.objects(ofType: RealmCoopPlayer.self).filter("ANY link.link.startTime=%@", startTime).flatMap({ $0.weaponList }))
            return weaponList.first(where: { $0.rawValue >= 20000 })
        }()

        /// バイト回数
        let shiftsWorked: Int = results.count

#warning("バグの可能性があるので将来的に修正予定")
        /// ウロコの枚数
        let scales: (bronze: Int, silver: Int, gold: Int) = {
            if shiftsWorked == 0 {
                return (bronze: 0, silver: 0, gold: 0)
            }
            let scales: [Int] = results.map({ Array($0.scale) }).transposed().map({ $0.compactMap({ $0 }).reduce(0, +) })
            return (bronze: scales[0], silver: scales[1], gold: scales[2])
        }()

        /// 失敗したWAVE
        let failureWaves: (clear: Int, wave1: Int, wave2: Int, wave3: Int) = {
            let failureWaves: NSCountedSet = NSCountedSet(array: results.map({ $0.failureWave ?? 0 }))
            return (
                clear: failureWaves.count(for: 0),
                wave1: failureWaves.count(for: 1),
                wave2: failureWaves.count(for: 2),
                wave3: failureWaves.count(for: 3)
            )
        }()

        /// クリアしたWAVE回数
        let shiftsClearWorked: Int = results.filter({ $0.isClear }).count

        /// オカシラシャケの出現数
        let bossCount: Int = results.compactMap({ $0.isBossDefeated }).count

        /// オカシラシャケの討伐数
        let bossKillCount: Int = results.filter({ $0.isBossDefeated == true }).count

        /// クマサンポイント
        let regularPoint: Int = results.sum(ofProperty: "kumaPoint") ?? 0

        /// チームの合計イクラ数
        let ikuraNum: Int = results.sum(ofProperty: "ikuraNum") ?? 0

        /// チームの合計金イクラ数
        let goldenIkuraNum: Int = results.sum(ofProperty: "goldenIkuraNum") ?? 0

        /// チームの救助数/被救助数合計
        let rescueCount: Int = players.sum(ofProperty: "helpCount") ?? 0

        /// 最高評価
        let gradeIdMax: GradeType = results.max(ofProperty: "grade") ?? GradeType.Apprentice

        /// 最高レート
        let gradePointMax: Int = results.max(ofProperty: "gradePoint") ?? 0

        /// 仮データ
        let stats: Stats = Stats(summation: 0, maximum: 0, minimum: 0, average: 0)
        let ikuraStats: Stats = {
            let summation: Int? = players.sum(ofProperty: "ikuraNum")
            let maximum: Int? = players.max(ofProperty: "ikuraNum")
            let minimum: Int? = players.min(ofProperty: "ikuraNum")
            let average: Double? = players.average(ofProperty: "ikuraNum")
            return Stats(summation: summation, maximum: maximum, minimum: minimum, average: average)
        }()
        let goldenIkuraStats: Stats = {
            let summation: Int? = players.sum(ofProperty: "goldenIkuraNum")
            let maximum: Int? = players.max(ofProperty: "goldenIkuraNum")
            let minimum: Int? = players.min(ofProperty: "goldenIkuraNum")
            let average: Double? = players.average(ofProperty: "goldenIkuraNum")
            return Stats(summation: summation, maximum: maximum, minimum: minimum, average: average)
        }()
        let helpStats: Stats = {
            let summation: Int? = players.sum(ofProperty: "helpCount")
            let maximum: Int? = players.max(ofProperty: "helpCount")
            let minimum: Int? = players.min(ofProperty: "helpCount")
            let average: Double? = players.average(ofProperty: "helpCount")
            return Stats(summation: summation, maximum: maximum, minimum: minimum, average: average)
        }()
        let deathStats: Stats = {
            let summation: Int? = players.sum(ofProperty: "deadCount")
            let maximum: Int? = players.max(ofProperty: "deadCount")
            let minimum: Int? = players.min(ofProperty: "deadCount")
            let average: Double? = players.average(ofProperty: "deadCount")
            return Stats(summation: summation, maximum: maximum, minimum: minimum, average: average)
        }()

        self.shiftsWorked = shiftsWorked
        self.clearRatio = Double(shiftsClearWorked) / Double(shiftsWorked)
        let clearWave = Double(results.map({ $0.waves.count }).reduce(0, +)) / Double(results.count)
        self.clearWave = clearWave
        self.bossDefeatedRatio = Double(bossKillCount) / Double(bossCount)
        self.bossCount = [bossKillCount, bossCount - bossKillCount]
        self.specialCounts = {
            // 支給されたスペシャル一覧
            let suppliedSpecialList: [SpecialType] = players.compactMap({ $0.specialId })
            return SpecialType.allCases.dropFirst().map({ id in suppliedSpecialList.filter({ $0 == id }).count })
        }()
        self.weaponList = weaponList
        self.weaponCounts = {
            // 支給されたブキ一覧
            let suppliedWeaponList: [WeaponType] = players.flatMap({ $0.weaponList })
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
        self.ikuraStats = ikuraStats
        self.goldenIkuraStats = goldenIkuraStats
        self.helpStats = helpStats
        self.deathStats = deathStats
        self.defeatedStats = {
            let summation: Int? = players.sum(ofProperty: "bossKillCountsTotal")
            let maximum: Int? = players.max(ofProperty: "bossKillCountsTotal")
            let minimum: Int? = players.min(ofProperty: "bossKillCountsTotal")
            let average: Double? = players.average(ofProperty: "bossKillCountsTotal")
            return Stats(summation: summation, maximum: maximum, minimum: minimum, average: average)
        }()
        self.waves = Array(repeating: Array(repeating: WaveStats(count: 0, ikuraStats: stats, goldenIkuraStats: stats, assistIkuraStats: stats), count: 9), count: 3)
        let maxGradePoint: Int? = results.max(ofProperty: "gradePoint")
        self.maxGradePoint = maxGradePoint
        self.gradePointHistory = results.compactMap({ $0.gradePoint }).map({ Double($0) })
        self.average = Grizzco.AverageData(
            weaponList: weaponList,
            rareWeapon: rareWeapon,
            ikuraNum: ikuraStats.average,
            goldenIkuraNum: goldenIkuraStats.average,
            helpCount: helpStats.average,
            deadCount: deathStats.average
        )
        self.point = Grizzco.PointData(
            playCount: shiftsWorked,
            ikuraNum: ikuraNum,
            goldenIkuraNum: goldenIkuraNum,
            bossKillCount: bossKillCount,
            regularPoint: regularPoint,
            regularPointTotal: nil,
            rescueCount: rescueCount
        )
        self.scale = Grizzco.ScaleData(gold: scales.gold, silver: scales.silver, bronze: scales.bronze)
        self.maximum = Grizzco.HighData(
            maxGrade: gradeIdMax,
            maxGradePoint: maxGradePoint,
            averageWaveCleared: clearWave
        )
    }
}


extension Collection where Self.Iterator.Element: RandomAccessCollection {
    // PRECONDITION: `self` must be rectangular, i.e. every row has equal size.
    func transposed() -> [[Self.Iterator.Element.Iterator.Element]] {
        guard let firstRow = self.first else { return [] }
        return firstRow.indices.map { index in
            self.map{ $0[index] }
        }
    }
}
