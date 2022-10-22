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

    /// メインウエポンデータ
    class WeaponData: ObservableObject {
        @Published var color: Color
        @Published var weaponId: WeaponType
        @Published var percent: Double?
        @Published var count: Int?

        init(color: Color, weaponId: WeaponType, count: Int?, percent: Double?) {
            self.color = color
            self.weaponId = weaponId
            self.percent = percent
            self.count = count
        }
    }

    /// スペシャルウェポンデータ
    struct SpecialData: Hashable, Equatable {
        let color: Color
        let specialId: SpecialType
        let percent: Double?
    }

    /// WAVEデータ
    struct WaveData: Hashable, Equatable {
        /// イベント
        let eventType: EventType
        /// 潮位
        let waterLevel: WaterType
        /// 出現回数
        let count: Int
        /// 最大金イクラ数
        let goldenIkuraMax: Int?
        /// 平均金イクラ数
        let goldenIkuraAvg: Double?
        /// クリア率
        let clearRatio: Double?
    }

    /// オオモノシャケデータ
    struct SakelienData: Hashable, Equatable {
        /// オオモノの種類
        let sakelienType: SakelienType
        /// オオモノ出現数
        let bossCount: Int
        /// オオモノ討伐合計
        let bossKillCount: Int
        /// チームオオモノ討伐合計
        let bossTeamKillCount: Int
    }

    class TeamData: ObservableObject {
        @Published var maxValue: Int?
        @Published var avgValue: Double?

        init(maxValue: Int?, avgValue: Double?) {
            self.maxValue = maxValue
            self.avgValue = avgValue
        }
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
    @Published var weapon: [Grizzco.WeaponData]
    /// クマサンブキデータ
    @Published var randoms: [Grizzco.WeaponData]
    /// クマサンWAVEデータ
    @Published var waves: [Grizzco.WaveData]
    /// クマサンスペシャルデータ
    @Published var specials: [Grizzco.SpecialData]
    /// クマサンシャケデータ
    @Published var sakelien: [Grizzco.SakelienData]
    /// イクラデータ
    @Published var ikuraNum: Grizzco.TeamData
    /// イクラデータ
    @Published var goldenIkuraNum: Grizzco.TeamData
    /// イクラデータ
    @Published var teamIkuraNum: Grizzco.TeamData
    /// イクラデータ
    @Published var teamGoldenIkuraNum: Grizzco.TeamData
    /// イクラデータ
    @Published var defeatedNum: Grizzco.TeamData
    /// イクラデータ
    @Published var teamDefeatedNum: Grizzco.TeamData
    /// ランダムシフトかどうか
    @Published var isRandomShift: Bool

    init(startTime: Date) {
        #warning("アプリがクラッシュするのでちょっとまずいが、まあヨシ")
        guard let schedule: RealmCoopSchedule = RealmService.shared.objects(ofType: RealmCoopSchedule.self).first(where: { $0.startTime == startTime }) else {
            fatalError()
        }
        /// リザルト一覧
        let results: RealmSwift.List<RealmCoopResult> = {
            if let results = RealmService.shared.objects(ofType: RealmCoopSchedule.self).first(where: { $0.startTime == startTime })?.results {
                return results
            }
            return RealmSwift.List<RealmCoopResult>()
        }()
        /// プレイヤー一覧
        let players: RealmSwift.Results<RealmCoopPlayer> = RealmService.shared.objects(ofType: RealmCoopPlayer.self).filter("ANY link.link.startTime=%@ AND isMyself=true", startTime)
        /// WAVE一覧
        let waves: RealmSwift.Results<RealmCoopWave> = RealmService.shared.objects(ofType: RealmCoopWave.self).filter("ANY link.link.startTime=%@", startTime)

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

        let weaponCounts: [(WeaponType, Int?)] = {
            if schedule.weaponList.contains(where: { $0.rawValue == -1 }) {
                return Array(zip(Array(repeating: WeaponType.Random_Green, count: 4), Array(repeating: nil, count: 4)))
            }
            // 支給されたブキ一覧
            let suppliedWeaponList: [WeaponType] = players.flatMap({ $0.weaponList })
            let suppliedWeaponCount: [Int] = weaponList.map({ id in suppliedWeaponList.filter({ $0 == id }).count })
            return Array(zip(weaponList, suppliedWeaponCount))
        }()

        print(weaponCounts)

        let randomWeaponCounts: [(WeaponType, Int)] = {
            let suppliedWeaponList: [WeaponType] = players.flatMap({ $0.weaponList })
            /// 支給されるブキ+支給されるクマサンブキを抽出
            let allWeapons: [WeaponType] = {
                let base: [WeaponType] = WeaponType.allCases.filter({ $0.rawValue >= 0 && $0.rawValue <= 20000 })
                if let rare: WeaponType = suppliedWeaponList.first(where: { $0.rawValue >= 20000 }) {
                    return base + [rare]
                }
                return base
            }()
            let suppliedWeaponCount: [Int] = allWeapons.map({ id in suppliedWeaponList.filter({ $0 == id }).count })
            return Array(zip(allWeapons, suppliedWeaponCount))
        }()

        self.isRandomShift = schedule.weaponList.contains(WeaponType.Random_Green)
        self.average = Grizzco.AverageData(
            weaponList: weaponList,
            rareWeapon: rareWeapon,
            ikuraNum: players.average(ofProperty: "ikuraNum"),
            goldenIkuraNum: players.average(ofProperty: "goldenIkuraNum"),
            helpCount: players.average(ofProperty: "helpCount"),
            deadCount: players.average(ofProperty: "deadCount")
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
        self.weapon = {
            let colors: [Color] = [
                SPColor.SplatNet3.SPPink,
                SPColor.SplatNet3.SPOrange,
                SPColor.SplatNet3.SPYellow,
                SPColor.SplatNet3.SPSalmonGreen
            ]

            let summation: Int = weaponCounts.compactMap({ $0.1 }).reduce(0, +)
            return zip(colors, weaponCounts).map({ color, weaponData in
                let percent: Double? = {
                    if summation == .zero {
                        return nil
                    }
                    if let count = weaponData.1 {
                        return Double(count) / Double(summation) * 100
                    }
                    return nil
                }()
                return Grizzco.WeaponData(color: color, weaponId: weaponData.0, count: weaponData.1, percent: percent)
            })
        }()
        self.randoms = {
            let colors: [Color] = Array(repeating: .black, count: randomWeaponCounts.count)
            let summation: Int = randomWeaponCounts.compactMap({ $0.1 }).reduce(0, +)
            return zip(colors, randomWeaponCounts).map({ color, weaponData in
                let percent: Double? = {
                    if summation == .zero {
                        return nil
                    }
                    return Double(weaponData.1) / Double(summation) * 100
                }()
                return Grizzco.WeaponData(color: color, weaponId: weaponData.0, count: weaponData.1, percent: percent)
            })
        }()

        self.waves = EventType.allCases.flatMap({ eventType in
            return WaterType.allCases.map({ waterLevel in
                let waves: RealmSwift.Results<RealmCoopWave> = waves.filter("waterLevel=%@ AND eventType=%@", waterLevel, eventType)
                let count: Int = waves.count
                let clearCount: Int = waves.filter({ $0.isClearWave }).count
                let goldenIkuraMax: Int? = waves.max(ofProperty: "goldenIkuraNum")
                let goldenIkuraAvg: Double? = waves.average(ofProperty: "goldenIkuraNum")
                return Grizzco.WaveData(
                    eventType: eventType,
                    waterLevel: waterLevel,
                    count: count,
                    goldenIkuraMax: goldenIkuraMax,
                    goldenIkuraAvg: goldenIkuraAvg,
                    clearRatio: count == .zero ? nil :Double(clearCount) / Double(count) * 100
                )
            })
        })
        self.specials = SpecialType.allCases.dropFirst().map({ specialId in
            let count: Int = players.filter("specialId=%@", specialId).count
            let percent: Double? = shiftsWorked == .zero ? nil : 100 * Double(count) / Double(shiftsWorked)
            return Grizzco.SpecialData(color: Color.black, specialId: specialId, percent: percent)
        })
        self.sakelien = []
        self.ikuraNum = Grizzco.TeamData(
            maxValue: players.max(ofProperty: "ikuraNum"),
            avgValue: players.average(ofProperty: "ikuraNum")
        )
        self.goldenIkuraNum = Grizzco.TeamData(
            maxValue: players.max(ofProperty: "goldenIkuraNum"),
            avgValue: players.average(ofProperty: "goldenIkuraNum")
        )
        self.teamIkuraNum = Grizzco.TeamData(
            maxValue: results.max(ofProperty: "ikuraNum"),
            avgValue: results.average(ofProperty: "ikuraNum")
        )
        self.teamGoldenIkuraNum = Grizzco.TeamData(
            maxValue: results.max(ofProperty: "goldenIkuraNum"),
            avgValue: results.average(ofProperty: "goldenIkuraNum")
        )
        self.defeatedNum = Grizzco.TeamData(
            maxValue: players.max(ofProperty: "bossKillCountsTotal"),
            avgValue: players.average(ofProperty: "bossKillCountsTotal")
        )
        self.teamDefeatedNum = Grizzco.TeamData(
            maxValue: players.max(ofProperty: "bossKillCountsTotal"),
            avgValue: players.average(ofProperty: "bossKillCountsTotal")
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
