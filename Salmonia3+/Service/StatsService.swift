//
//  StatsService.swift
//  Salmonia3+
//
//  Created by devonly on 2022/10/08.
//

import Foundation
import RealmSwift
import SplatNet3
import SwiftUI

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


    class WeaponData: ObservableObject {
        @Published var weaponList: [WeaponDataType]

        struct WeaponDataType {
            let color: Color
            let weaponId: WeaponType
            let percent: Double
        }

        init(weaponList: [(WeaponType, Int)]) {
            let colors: [Color] = [
                SPColor.SplatNet3.SPPink,
                SPColor.SplatNet3.SPOrange,
                SPColor.SplatNet3.SPYellow,
                SPColor.SplatNet3.SPSalmonGreen
            ]

            let summation: Int = weaponList.map({ $0.1 }).reduce(0, +)

            self.weaponList = zip(weaponList, colors).map({ WeaponDataType(color: $0.1, weaponId: $0.0.0, percent: Double($0.0.1) / Double(summation)) })
        }
    }

    struct SpecialData: Hashable, Equatable {
        let color: Color
        let weaponId: WeaponType
        let percent: Double
    }

    struct WaveData: Hashable, Equatable {
        /// イベント
        let eventType: EventType
        /// 潮位
        let waterLevel: WaterType
        /// 出現回数
        let count: Int
        /// 最大金イクラ数
        let goldenIkuraMax: Int
        /// 平均金イクラ数
        let goldenIkuraAvg: Double
    }
}

final class StatsService: ObservableObject {
    /// クマサンポイントデータ
    @Published var point: Grizzco.PointData
    /// クマサンカードデータ
    @Published var average: Grizzco.AverageData
    /// クマサンウロコデータ
    @Published var scale: Grizzco.ScaleData
    /// クマサン最高データ
    @Published var maximum: Grizzco.HighData
    /// クマサンブキデータ
    @Published var weapon: Grizzco.WeaponData
    /// クマサンWAVEデータ
    @Published var waves: [Grizzco.WaveData]

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
        /// 平均クリアWAVE
        let clearWave: Double? = {
            if results.count == .zero {
                return nil
            }
            return Double(failureWaves.clear * 3 + failureWaves.wave3 * 2 + failureWaves.wave2 * 1) / Double(results.count)
        }()
        /// オカシラシャケの討伐数
        let bossKillCount: Int = results.filter({ $0.isBossDefeated == true }).count
        /// クマサンポイント
        let regularPoint: Int? = results.sum(ofProperty: "kumaPoint")
        /// チームの合計イクラ数
        let ikuraNum: Int? = results.sum(ofProperty: "ikuraNum")
        /// チームの合計金イクラ数
        let goldenIkuraNum: Int? = results.sum(ofProperty: "goldenIkuraNum")
        /// チームの救助数/被救助数合計
        let rescueCount: Int? = players.sum(ofProperty: "helpCount")
        /// 最高評価
        let gradeIdMax: GradeType? = results.max(ofProperty: "grade")
        /// 最高レート
        let gradePointMax: Int? = {
            guard let gradeIdMax = gradeIdMax else {
                return nil
            }
            return results.filter("grade=%@", gradeIdMax).max(ofProperty: "gradePoint")
        }()

        let weaponCounts: [(WeaponType, Int)] = {
            // 支給されたブキ一覧
            let suppliedWeaponList: [WeaponType] = players.flatMap({ $0.weaponList })
            let suppliedWeaponCount: [Int] = weaponList.map({ id in suppliedWeaponList.filter({ $0 == id }).count })
            return Array(zip(suppliedWeaponList, suppliedWeaponCount))
        }()

        self.average = Grizzco.AverageData(
            weaponList: weaponList,
            rareWeapon: rareWeapon,
            ikuraNum: results.average(ofProperty: "ikuraNum"),
            goldenIkuraNum: results.average(ofProperty: "goldenIkuraNum"),
            helpCount: results.average(ofProperty: "helpCount"),
            deadCount: results.average(ofProperty: "deathCount")
        )
        self.point = Grizzco.PointData(
            playCount: shiftsWorked == .zero ? nil : shiftsWorked,
            ikuraNum: ikuraNum == .zero ? nil : ikuraNum,
            goldenIkuraNum: goldenIkuraNum == .zero ? nil : goldenIkuraNum,
            bossKillCount: bossKillCount == .zero ? nil : bossKillCount,
            regularPoint: regularPoint == .zero ? nil : regularPoint,
            regularPointTotal: nil,
            rescueCount: rescueCount == .zero ? nil : rescueCount
        )
        self.scale = Grizzco.ScaleData(gold: scales.gold, silver: scales.silver, bronze: scales.bronze)
        self.maximum = Grizzco.HighData(
            maxGrade: gradeIdMax,
            maxGradePoint: gradePointMax,
            averageWaveCleared: clearWave
        )
        self.weapon = Grizzco.WeaponData(weaponList: weaponCounts)
        self.waves = []
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
