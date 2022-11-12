//
//  GrizzcoChartEntry.swift
//  Salmonia3+
//
//  Created by tkgstrator on 2022/10/30.
//

import Foundation
import RealmSwift
import SplatNet3

enum Grizzco {
    struct Entry<T: RawRepresentable>: Identifiable {
        let id: UUID = UUID()
        let key: T
        let count: Int
        let percent: Double?

        init(key: T, count: Int, percent: Double?) {
            self.key = key
            self.count = count
            self.percent = percent
        }
    }

    class AverageData: ObservableObject {
        @Published var goldenIkuraNum: Double? = nil
        @Published var ikuraNum: Double? = nil
        @Published var deadCount: Double? = nil
        @Published var helpCount: Double? = nil
        @Published var rareWeapon: WeaponType? = nil
        @Published var weaponList: [WeaponType] = []
        @Published var chart: PlotChartEntryData = PlotChartEntryData()

        init() {}

        init(schedule: RealmCoopSchedule, players: RealmSwift.Results<RealmCoopPlayer>) {
            self.ikuraNum = players.average(ofProperty: "ikuraNum")
            self.goldenIkuraNum = players.average(ofProperty: "goldenIkuraNum")
            self.deadCount = players.average(ofProperty: "deadCount")
            self.helpCount = players.average(ofProperty: "helpCount")
            self.rareWeapon = players.flatMap({ $0.weaponList }).first(where: { $0.rawValue >= 20000 })
            self.weaponList = Array(schedule.weaponList)
            self.chart = PlotChartEntryData(
                legend: .Common_Ikura_Ratio,
                entries: [
                    players.asPlotChartEntry(id: .Common_Player_You),
                    schedule.results.asPlotChartEntry(id: .Common_Player_Crew)
                ]
            )
        }
    }

    class SpecialData: ObservableObject {
        @Published var entries: [Entry<SpecialType>] = []

        init() {}
        
        init(players: RealmSwift.Results<RealmCoopPlayer>) {
            self.entries = players.specialEntries
        }
    }

    class WaveEvent: ObservableObject {
        @Published var waves: [Entry] = []
        @Published var extra: [Entry] = []

        init() {}

        init(waves: RealmSwift.Results<RealmCoopWave>) {
            self.waves = EventType.allCases.flatMap({ eventType in
                WaterType.allCases.map({ waterLevel in
                    let waves: RealmSwift.Results<RealmCoopWave> = waves.filter("eventType=%@ AND waterLevel=%@ AND id!=4", eventType, waterLevel)
                    let isAvailable: Bool = {
                        /// 干潮が存在しない
                        if (waterLevel == .Low_Tide && [EventType.Rush, EventType.Goldie_Seeking, EventType.Griller, EventType.Mudmouth].contains(eventType)) {
                            return false
                        }
                        /// 干潮以外が存在しない
                        if (waterLevel != .Low_Tide && [EventType.Giant, .Cohock_Charge].contains(eventType)) {
                            return false
                        }
                        return true
                    }()
                    return Entry(
                        eventType: eventType,
                        waterLevel: waterLevel,
                        clear: waves.filter({ $0.isClearWave }).count,
                        count: waves.count,
                        goldenIkuraMax: waves.max(ofProperty: "goldenIkuraNum") ?? .zero,
                        goldenIkuraAvg: waves.average(ofProperty: "goldenIkuraNum") ?? .zero,
                        clearRatio: waves.count == .zero ? nil : Double(waves.filter({ $0.isClearWave }).count) / Double(waves.count) * 100,
                        isAvailable: isAvailable
                    )
                })
            })
            let waves: RealmSwift.Results<RealmCoopWave> = waves.filter("id==4")
            self.extra = WaterType.allCases.map({ waterLevel in
                let waves: RealmSwift.Results<RealmCoopWave> = waves.filter("waterLevel=%@", waterLevel)
                return Entry(
                    eventType: nil,
                    waterLevel: waterLevel,
                    clear: waves.filter({ $0.isClearWave }).count,
                    count: waves.count,
                    goldenIkuraMax: waves.max(ofProperty: "goldenIkuraNum") ?? .zero,
                    goldenIkuraAvg: waves.average(ofProperty: "goldenIkuraNum") ?? .zero,
                    clearRatio: waves.count == .zero ? nil : Double(waves.filter({ $0.isClearWave }).count) / Double(waves.count) * 100,
                    isAvailable: true
                )
            })
        }

        struct Entry: Identifiable {
            var id: UUID = UUID()
            let eventType: EventType?
            let waterLevel: WaterType
            let clear: Int
            let count: Int
            let goldenIkuraMax: Int
            let goldenIkuraAvg: Double
            let clearRatio: Double?
            let isAvailable: Bool
        }
    }

    /// ポイントカード
    class PointCard: ObservableObject {
        @Published var kumaPoint: Int? = nil
        @Published var shiftWorked: Int? = nil
        @Published var goldenIkuraNum: Int? = nil
        @Published var ikuraNum: Int? = nil
        @Published var bossKillCounts: Int? = nil
        @Published var helpCount: Int? = nil
        @Published var deathCount: Int? = nil
        /// キケン度のチャート
        @Published var chart: LineChartEntryData = LineChartEntryData()

        init() {}
        
        init(results: RealmSwift.List<RealmCoopResult>, players: RealmSwift.Results<RealmCoopPlayer>) {
            /// バイト回数が0なら何も計算しない
            if results.count == .zero { return }

            self.kumaPoint = results.sum(ofProperty: "kumaPoint")
            self.shiftWorked = results.count
            self.goldenIkuraNum = players.sum(ofProperty: "goldenIkuraNum")
            self.ikuraNum = players.sum(ofProperty: "ikuraNum")
            self.bossKillCounts = results.filter("isBossDefeated=true").count
            self.helpCount = players.sum(ofProperty: "helpCount")
            self.deathCount = players.sum(ofProperty: "deadCount")
            self.chart = LineChartEntryData(
                legend: .CoopHistory_DangerRatio,
                entries: [
                    results.filter({ $0.dangerRate != .zero }).map({ $0.dangerRate * 100 }).asLineChartEntry(id: .Common_Actual_Value),
                    results.filter({ $0.dangerRate != .zero }).compactMap({ $0.estimatedDangerRate }).asLineChartEntry(id: .Common_Estimated_Value),
                ])
        }
    }

    /// 獲得したウロコ
    class ScaleCount: ObservableObject {
        @Published var gold: Int? = nil
        @Published var silver: Int? = nil
        @Published var bronze: Int? = nil

        init() {}

        init(results: RealmSwift.List<RealmCoopResult>) {
            let scales: [Int] = results.scalesCount

            if scales.count != 3 {
               return
            }

            self.bronze = scales[0]
            self.silver = scales[1]
            self.gold = scales[2]
        }
    }

    /// 支給されたブキ
    class WeaponData: ObservableObject {
        @Published var suppliedWeaponCount: Int? = nil
        @Published var weaponCountTotal: Int? = nil
        @Published var estimateCompleteCount: Int? = nil
        @Published var isRandom: Bool = false
        @Published var entries: [Entry<WeaponType>] = []

        init() {}

        init(schedule: RealmCoopSchedule, players: RealmSwift.Results<RealmCoopPlayer>) {
            let isRandom: Bool = schedule.weaponList.contains(.Random_Green)
            self.isRandom = isRandom
            self.suppliedWeaponCount = Set(players.flatMap({ $0.weaponList })).count
            self.weaponCountTotal = WeaponType.randoms.count + 1
            self.entries = {
                if isRandom {
                    return players.weaponEntries
                }
                let weaponList: [WeaponType] = players.flatMap({ $0.weaponList })
                return Array(schedule.weaponList)
                    .map({ weaponId in
                        weaponList.count(weaponId)
                    })
                    .map({ weaponId, count in
                        Entry<WeaponType>(
                            key: weaponId,
                            count: count,
                            percent: weaponList.count == .zero ? nil : Double(count) / Double(weaponList.count) * 100
                        )
                    })
            }()
        }
    }

    /// ハイスコア
    class HighScore: ObservableObject {
        @Published var averageWaveCleared: Double? = nil
        @Published var maxGrade: GradeType? = nil
        @Published var maxGradePoint: Int? = nil
        /// 評価レートのチャート
        @Published var chart: LineChartEntryData = LineChartEntryData()

        init() {}
        
        init(results: RealmSwift.List<RealmCoopResult>) {
            /// バイト回数が0なら何も計算しない
            if results.count == .zero { return }

            guard let maxGrade: GradeType = results.max(ofProperty: "grade") else {
                return
            }
            self.averageWaveCleared = results.averageWaveCleared
            self.maxGrade = results.max(ofProperty: "grade")
            self.maxGradePoint = results.filter("grade=%@", maxGrade).max(ofProperty: "gradePoint")
            self.chart = LineChartEntryData(
                legend: .Common_Grade_Point,
                entries: [
                    results.filter({ $0.dangerRate != .zero }).compactMap({ $0.gradePoint }).asLineChartEntry(id: .Common_Player_You),
                    results.filter({ $0.dangerRate != .zero }).compactMap({ $0.gradePointCrew }).asLineChartEntry(id: .Common_Player_Crew),
                ])
        }
    }
}

extension Array where Element: Hashable {
    func count() -> [(element: Element, count: Int)] {
        let elements: Set<Element> = Set(self)
        return elements.map({ self.count($0) })
    }

    func count(_ element: Element) -> (element: Element, count: Int) {
        (element: element, self.filter({ $0 == element }).count)
    }
}

//public enum Grizzco {
//    public enum Record {
//        /// 総合記録
//        class Total: ObservableObject {
//            @Published var bossCounts: [BossCount] = []
//            @Published var bossKillCounts: [BossCount] = []
//            @Published var teamKillCounts: [BossCount] = []
//
//            init(results: RealmSwift.Results<RealmCoopResult>, players: RealmSwift.Results<RealmCoopPlayer>) {
//                if results.isEmpty { return }
//                let bossCounts: [Int] = sum(of: results.map({ Array($0.bossCounts) }))
//                let bossKillCounts: [Int] = sum(of: players.map({ Array($0.bossKillCounts) }))
//                let teamKillCounts: [Int] = sum(of: results.map({ Array($0.bossKillCounts) }))
//
//                SakelienType.allCases.enumerated().prefix(11).forEach({ index, sakelienId in
//                    self.bossCounts.append(BossCount(bossId: sakelienId, count: bossCounts[index]))
//                    self.bossKillCounts.append(BossCount(bossId: sakelienId, count: bossKillCounts[index]))
//                    self.teamKillCounts.append(BossCount(bossId: sakelienId, count: teamKillCounts[index]))
//                })
//            }
//
//            class BossCount: ObservableObject, Identifiable {
//                @Published var id: UUID = UUID()
//                @Published var bossId: SakelienType
//                @Published var count: Int = 0
//
//                init(bossId: SakelienType, count: Int) {
//                    self.bossId = bossId
//                    self.count = count
//                }
//            }
//        }
//
//        /// ステージ記録
//        class Stage: ObservableObject, Identifiable {
//            @Published var id: UUID = UUID()
//            @Published var stageId: StageType = .Unknown
//            @Published var maxGrade: GradeType? = nil
//            @Published var maxGradePoint: Int? = nil
//            @Published var minimumCount: Int? = nil
//            @Published var goldenIkuraMax: Int? = nil
//            @Published var ikuraMax: Int? = nil
//            @Published var teamGoldenIkuraMax: Int? = nil
//            @Published var teamIkuraMax: Int? = nil
//
//            internal init(
//                stageId: StageType = .Unknown,
//                maxGrade: GradeType? = nil,
//                maxGradePoint: Int? = nil,
//                minimumCount: Int? = nil,
//                goldenIkuraMax: Int? = nil,
//                ikuraMax: Int? = nil,
//                teamGoldenIkuraMax: Int? = nil,
//                teamIkuraMax: Int? = nil
//            ) {
//                self.id = id
//                self.stageId = stageId
//                self.maxGrade = maxGrade
//                self.maxGradePoint = maxGradePoint
//                self.minimumCount = minimumCount
//                self.goldenIkuraMax = goldenIkuraMax
//                self.ikuraMax = ikuraMax
//                self.teamGoldenIkuraMax = teamGoldenIkuraMax
//                self.teamIkuraMax = teamIkuraMax
//            }
//
//            init(
//                stageId: StageType,
//                results: RealmSwift.Results<RealmCoopResult>,
//                players: RealmSwift.Results<RealmCoopPlayer>
//            ) {
//                guard let grade: GradeType = results.max(ofProperty: "grade") else {
//                    return
//                }
//                self.stageId = stageId
//                self.maxGrade = grade
//                self.maxGradePoint = results.filter("grade =%@", grade).max(ofProperty: "gradePoint")
//                self.goldenIkuraMax = players.max(ofProperty: "goldenIkuraNum")
//                self.teamGoldenIkuraMax = results.max(ofProperty: "goldenIkuraNum")
//                self.ikuraMax = players.max(ofProperty: "ikuraNum")
//                self.teamIkuraMax = results.max(ofProperty: "ikuraNum")
//            }
//        }
//    }
//
//    /// チャート
//    public enum Chart {
//        /// 平均値
//        class Average: ObservableObject {
//            @Published var weaponList: [WeaponType] = []
//            @Published var rareWeapon: WeaponType? = nil
//            @Published var goldenIkuraNum: Double? = nil
//            @Published var ikuraNum: Double? = nil
//            @Published var helpCount: Double? = nil
//            @Published var deadCount: Double? = nil
//
//            init() {}
//
//            init(schedule: RealmCoopSchedule, players: RealmSwift.Results<RealmCoopPlayer>) {
//                self.weaponList = Array(schedule.weaponList)
//                self.rareWeapon = schedule.results.rareWeapon
//                self.goldenIkuraNum = players.average(ofProperty: "goldenIkuraNum")
//                self.ikuraNum = players.average(ofProperty: "ikuraNum")
//                self.helpCount = players.average(ofProperty: "helpCount")
//                self.deadCount = players.average(ofProperty: "deadCount")
//            }
//        }
//
//        ///
//        class Card: ObservableObject {
//            @Published var playCount: Int? = nil
//            @Published var goldenIkuraNum: Int? = nil
//            @Published var ikuraNum: Int? = nil
//            @Published var bossKillCount: Int? = nil
//            @Published var regularPoint: Int? = nil
//            @Published var helpCount: Int? = nil
//            @Published var charts: [Grizzco.ChartEntrySet] = []
//
//            init() {}
//
//            init(results: RealmSwift.List<RealmCoopResult>, players: RealmSwift.Results<RealmCoopPlayer>) {
//                if results.count == .zero { return }
//                self.playCount = results.count
//                self.goldenIkuraNum = results.sum(ofProperty: "goldenIkuraNum")
//                self.ikuraNum = results.sum(ofProperty: "ikuraNum")
//                self.bossKillCount = results.filter({ $0.isBossDefeated == true }).count
//                self.regularPoint = results.sum(ofProperty: "kumaPoint")
//                self.helpCount = players.sum(ofProperty: "helpCount")
//                self.charts = [
//                    results.map({ $0.dangerRate * 100 }).asLineChartEntry(id: .CoopHistory_DangerRatio)
//                ]
//            }
//        }
//
//        class Maximum: ObservableObject {
//            @Published var maxGrade: GradeType? = nil
//            @Published var maxGradePoint: Int? = nil
//            @Published var averageWaveCleared: Double? = nil
//            @Published var charts: [Grizzco.ChartEntrySet] = []
//
//            init() {}
//
//            init(results: RealmSwift.List<RealmCoopResult>) {
//                if results.count == .zero { return }
//                guard let maxGrade: GradeType = results.max(ofProperty: "grade") else { return }
//                self.maxGrade = maxGrade
//                self.maxGradePoint = results.filter("grade=%@", maxGrade).max(ofProperty: "gradePoint")
//                self.averageWaveCleared = results.averageWaveCleared
//                self.charts = [
//                    results.compactMap({ $0.dangerRate == .zero ? nil : $0.gradePoint }).asLineChartEntry(id: .Common_Player_You),
//                    results.compactMap({ $0.gradePointCrew }).asLineChartEntry(id: .Common_Player_Crew)
//                ]
//            }
//        }
//
//        class Scale: ObservableObject {
//            @Published var gold: Int? = nil
//            @Published var silver: Int? = nil
//            @Published var bronze: Int? = nil
//
//            init() {}
//
//            init(results: RealmSwift.List<RealmCoopResult>) {
//                if results.count == .zero { return }
//                var scales: [Int] = results.scalesCount
//                self.bronze = scales.removeFirst()
//                self.silver = scales.removeFirst()
//                self.gold = scales.removeFirst()
//            }
//        }
//
//        class Scatters: ObservableObject {
//            @Published var entries: [PointEntry] = []
//
//            init() {}
//
//            init(results: RealmSwift.List<RealmCoopResult>) {
//                self.entries = results.compactMap({ result in
//                    guard let player: RealmCoopPlayer = result.players.first else {
//                        return nil
//                    }
//                    return PointEntry(
//                        xValue: Double(player.goldenIkuraNum) / Double(result.goldenIkuraNum) * 100,
//                        yValue: Double(player.ikuraNum) / Double(result.ikuraNum) * 100,
//                        isClear: result.isClear
//                    )
//                })
//            }
//        }
//
//        class Weapons: ObservableObject {
//            /// 支給されたブキの数
//            @Published var suppliedWeaponCount: Int?
//            /// 支給される可能性のあるブキの数
//            @Published var weaponCount: Int?
//            /// 推定コンプリート回数
//            @Published var estimateCompleteCount: Int?
//            /// データ
//            @Published var entries: [Entry] = []
//            /// ランダム編成かどうか
//            @Published var isRandom: Bool = false
//
//            init() {}
//
//            init(schedule: RealmCoopSchedule, players: RealmSwift.Results<RealmCoopPlayer>) {
//                let isRandom: Bool = schedule.weaponList.contains(.Random_Green)
//                self.isRandom = isRandom
//                self.suppliedWeaponCount = players.suppliedWeaponSet.count
//                self.weaponCount = WeaponType.randoms.count + 1
//                self.entries = {
//                    if isRandom {
//                        return players.suppliedWeaponEntry
//                    }
//                    let suppliedList: [WeaponType] = players.flatMap({ $0.weaponList })
//                    return Array(schedule.weaponList)
//                        .map({ weaponId in
//                            suppliedList.count(weaponId)
//                        })
//                        .map({ weaponId, count in
//                            Entry(
//                                id: weaponId,
//                                count: count,
//                                percent: suppliedList.count == .zero ? nil : Double(count) / Double(suppliedList.count) * 100)
//                        })
//                        .sorted(by: { $0.count < $1.count })
//                }()
//            }
//
//            struct Entry: Identifiable {
//                let id: WeaponType
//                let count: Int
//                let percent: Double?
//
//                init(id: WeaponType, count: Int, percent: Double?) {
//                    self.id = id
//                    self.count = count
//                    self.percent = percent
//                }
//            }
//        }
//
//        class SpecialWeapons: ObservableObject {
//            @Published var entries: [Entry] = []
//
//            init() {}
//
//            init(players: RealmSwift.Results<RealmCoopPlayer>) {
//                self.entries = players.suppliedSpecialEntry
//            }
//
//            struct Entry: Identifiable {
//                let id: SpecialType
//                let count: Int?
//                let percent: Double?
//
//                init(id: SpecialType, count: Int? = nil, percent: Double? = nil) {
//                    self.id = id
//                    self.count = count
//                    self.percent = percent
//                }
//            }
//        }
//
//        class Sakelien: ObservableObject {
//            @Published var series: [SakelienEntry] = []
//
//            struct SakelienEntry: Identifiable {
//                let id: SakelienType
//                let bossCount: Int?
//                let bossKillCount: Int?
//                let bossTeamKillCount: Int?
//            }
//        }
//
//        public class Values: ObservableObject {
//            @Published var goldenIkuraNum: [ValueEntry] = []
//            @Published var ikuraNum: [ValueEntry] = []
//            @Published var helpCount: [ValueEntry] = []
//            @Published var deadCount: [ValueEntry] = []
//            @Published var defeatedCount: [ValueEntry] = []
//
//            init() {}
//
//            init(results: RealmSwift.List<RealmCoopResult>, players: RealmSwift.Results<RealmCoopPlayer>) {
//                self.goldenIkuraNum = [
//                    ValueEntry(
//                        title: .CoopHistory_GoldenDeliverCount,
//                        id: .Solo,
//                        icon: .GoldenIkura,
//                        values: players.map({ $0.goldenIkuraNum }),
//                        waves: players.map({ $0.goldenIkuraNumPerWave })
//                    ),
//                    ValueEntry(
//                        title: .CoopHistory_GoldenDeliverCount,
//                        id: .Team,
//                        icon: .GoldenIkura,
//                        values: results.map({ $0.goldenIkuraNum }),
//                        waves: results.map({ $0.goldenIkuraNumPerWave }))
//                ]
//                self.ikuraNum = [
//                    ValueEntry(
//                        title: .CoopHistory_DeliverCount,
//                        id: .Solo,
//                        icon: .Ikura,
//                        values: players.map({ $0.ikuraNum }),
//                        waves: players.map({ $0.ikuraNumPerWave })),
//                    ValueEntry(
//                        title: .CoopHistory_DeliverCount,
//                        id: .Team,
//                        icon: .Ikura,
//                        values: results.map({ $0.ikuraNum }),
//                        waves: results.map({ $0.ikuraNumPerWave }))
//                ]
//                self.defeatedCount = [
//                    ValueEntry(
//                        title: .CoopHistory_Enemy,
//                        id: .Solo,
//                        icon: .Salmon,
//                        values: players.map({ $0.bossKillCountsTotal }),
//                        waves: players.map({ $0.bossKillCountsTotalPerWave })),
//                    ValueEntry(
//                        title: .CoopHistory_Enemy,
//                        id: .Team,
//                        icon: .Salmon,
//                        values: results.map({ $0.bossKillCounts.sum() }),
//                        waves: results.map({ $0.bossKillCountsTotalPerWave }))
//                ]
//                self.helpCount = [
//                    ValueEntry(
//                        title: .CoopHistory_RescueCount,
//                        id: .Solo,
//                        icon: .Ikura,
//                        values: players.map({ $0.helpCount }))
//                ]
//                self.deadCount = [
//                    ValueEntry(
//                        title: .CoopHistory_RescuedCount,
//                        id: .Solo,
//                        icon: .Ikura,
//                        values: players.map({ $0.deadCount }))
//                ]
//            }
//
//            public class ValueEntry: ObservableObject, Identifiable {
//                @Published public var id: UUID = UUID()
//                @Published var type: ChartType = .Solo
//                @Published var icon: ChartIconType = .GoldenIkura
//                @Published var maxValue: Int? = nil
//                @Published var avgValue: Double? = nil
//                @Published var charts: Grizzco.ChartEntrySet
//
//                init<T: BinaryInteger, S: BinaryFloatingPoint>(title: LocalizedType, id: ChartType, icon: ChartIconType, values: [T?], waves: [S?] = []) {
//                    self.type = id
//                    self.icon = icon
//                    self.maxValue = {
//                        if let maxValue = values.compactMap({ $0 }).max() {
//                            return Int(maxValue)
//                        }
//                        return nil
//                    }()
//                    let values: [S] = waves.compactMap({ $0 })
//                    self.avgValue = {
//                        if values.isEmpty { return nil }
//                        return values.map({ Double($0) }).reduce(0, +) / Double(values.count)
//                    }()
//                    self.charts = values.asLineChartEntry(id: title)
//                }
//
//                init<T: BinaryInteger>(title: LocalizedType, id: ChartType, icon: ChartIconType, values: [T?]) {
//                    self.type = id
//                    self.icon = icon
//                    let values: [T] = values.compactMap({ $0 })
//                    self.maxValue = {
//                        if let maxValue = values.compactMap({ $0 }).max() {
//                            return Int(maxValue)
//                        }
//                        return nil
//                    }()
//                    self.avgValue = {
//                        if values.isEmpty { return nil }
//                        return values.map({ Double($0) }).reduce(0, +) / Double(values.count)
//                    }()
//                    self.charts = values.asLineChartEntry(id: title)
//                }
//            }
//        }
//
//        class Wave: ObservableObject {
//            @Published var entries: [WaveEntry] = []
//            @Published var extra: [WaveEntry] = []
//
//            struct WaveEntry: Identifiable {
//                var id: UUID = UUID()
//                let eventType: EventType?
//                let waterLevel: WaterType
//                let clear: Int
//                let count: Int
//                let goldenIkuraMax: Int
//                let goldenIkuraAvg: Double
//                let clearRatio: Double?
//                let isAvailable: Bool
//            }
//
//            init() {}
//
//            init(waves: RealmSwift.Results<RealmCoopWave>) {
//                self.entries = EventType.allCases.flatMap({ eventType in
//                    WaterType.allCases.map({ waterLevel in
//                        let waves: RealmSwift.Results<RealmCoopWave> = waves.filter("eventType=%@ AND waterLevel=%@ AND id!=4", eventType, waterLevel)
//                        let isAvailable: Bool = {
//                            /// 干潮が存在しない
//                            if (waterLevel == .Low_Tide && [EventType.Rush, EventType.Goldie_Seeking, EventType.Griller, EventType.Mudmouth].contains(eventType)) {
//                                return false
//                            }
//                            /// 干潮以外が存在しない
//                            if (waterLevel != .Low_Tide && [EventType.Giant, .Cohock_Charge].contains(eventType)) {
//                                return false
//                            }
//                            return true
//                        }()
//                        return WaveEntry(
//                            eventType: eventType,
//                            waterLevel: waterLevel,
//                            clear: waves.filter({ $0.isClearWave }).count,
//                            count: waves.count,
//                            goldenIkuraMax: waves.max(ofProperty: "goldenIkuraNum") ?? .zero,
//                            goldenIkuraAvg: waves.average(ofProperty: "goldenIkuraNum") ?? .zero,
//                            clearRatio: waves.count == .zero ? nil : Double(waves.filter({ $0.isClearWave }).count) / Double(waves.count) * 100,
//                            isAvailable: isAvailable
//                        )
//                    })
//                })
//                let waves: RealmSwift.Results<RealmCoopWave> = waves.filter("id==4")
//                self.extra = WaterType.allCases.map({ waterLevel in
//                    let waves: RealmSwift.Results<RealmCoopWave> = waves.filter("waterLevel=%@", waterLevel)
//                    return WaveEntry(
//                        eventType: nil,
//                        waterLevel: waterLevel,
//                        clear: waves.filter({ $0.isClearWave }).count,
//                        count: waves.count,
//                        goldenIkuraMax: waves.max(ofProperty: "goldenIkuraNum") ?? .zero,
//                        goldenIkuraAvg: waves.average(ofProperty: "goldenIkuraNum") ?? .zero,
//                        clearRatio: waves.count == .zero ? nil : Double(waves.filter({ $0.isClearWave }).count) / Double(waves.count) * 100,
//                        isAvailable: true
//                    )
//                })
//            }
//        }
//    }
//}

//extension RealmSwift.Results where Element == RealmCoopResult {
//}
//
//extension RealmSwift.List where Element == RealmCoopResult {
//    fileprivate var scalesCount: [Int] {
//        self.map({ Array($0.scale) }).transposed().map({ $0.compactMap({ $0 }).reduce(0, +) })
//    }
//
//    fileprivate var rareWeapon: WeaponType? {
//        self.flatMap({ $0.players.flatMap({ $0.weaponList }) }).first(where: { $0.rawValue >= 20000 })
//    }
//
//    fileprivate var averageWaveCleared: Double? {
//        if self.count == .zero { return nil }
//        let failureWaveTotal: Int = self.compactMap({ $0.failureWave }).map({ 4 - $0 }).reduce(0, +)
//        return 3.0 - Double(failureWaveTotal) / Double(self.count)
//    }
//}
//
//extension Array where Element: Hashable {
//    func count() -> [(element: Element, count: Int)] {
//        let elements: Set<Element> = Set(self)
//        return elements.map({ self.count($0) })
//    }
//
//    func count(_ element: Element) -> (element: Element, count: Int) {
//        (element: element, self.filter({ $0 == element }).count)
//    }
//}
//
//extension RealmSwift.Results where Element == RealmCoopPlayer {
//    typealias WeaponEntry = Grizzco.Chart.Weapons.Entry
//    typealias SpecialEntry = Grizzco.Chart.SpecialWeapons.Entry
//
//    /// 支給されたブキ
//    fileprivate var suppliedWeaponSet: Set<WeaponType> {
//        Set(self.flatMap({ Array($0.weaponList) }))
//    }
//
//    /// ランダム編成で支給された回数
//    var suppliedWeaponEntry: [WeaponEntry] {
//        let suppliedList: [WeaponType] = self.flatMap({ $0.weaponList })
//        let randoms: Set<WeaponType> = Set(suppliedList).union(WeaponType.randoms)
//        return randoms
//            .map({ weaponId in
//                suppliedList.count(weaponId)
//            })
//            .map({ weaponId, count in
//                WeaponEntry(
//                    id: weaponId,
//                    count: count,
//                    percent: suppliedList.count == .zero ? nil : Double(count) / Double(suppliedList.count) * 100)
//            })
//            .sorted(by: { $0.count < $1.count })
//    }
//
//    fileprivate var suppliedSpecialEntry: [SpecialEntry] {
//        let specialList: [SpecialType] = Array(SpecialType.allCases.dropFirst())
//        let suppliedSpecials: [SpecialType] = self.compactMap({ $0.specialId })
//        if suppliedSpecials.count == .zero {
//            return specialList.map({ suppliedSpecials.count($0) }).map({ SpecialEntry(id: $0.element, count: nil, percent: nil) })
//        }
//        return specialList.map({ suppliedSpecials.count($0) }).map({ SpecialEntry(id: $0.element, count: $0.count, percent: Double($0.count) / Double(suppliedSpecials.count) * 100) })
//    }
//}
//
//extension RealmCoopPlayer {
//    var goldenIkuraNumPerWave: Double? {
//        if self.specialCounts.count == .zero {
//            return nil
//        }
//        return Double(self.goldenIkuraNum) * 3 / Double(self.specialCounts.count)
//    }
//
//    var ikuraNumPerWave: Double? {
//        if self.specialCounts.count == .zero {
//            return nil
//        }
//        return Double(self.ikuraNum) * 3 / Double(self.specialCounts.count)
//    }
//
//    var bossKillCountsTotalPerWave: Double? {
//        if self.specialCounts.count == .zero {
//            return nil
//        }
//        return Double(self.bossKillCountsTotal) * 3 / Double(self.specialCounts.count)
//    }
//}
//
//extension RealmCoopSchedule {
//    typealias WeaponEntry = Grizzco.Chart.Weapons.Entry
//
//    var suppliedWeaponEntry: [WeaponEntry] {
//        self.weaponList.map({ WeaponEntry(id: $0, count: 0, percent: nil) })
//    }
//}
//
//extension RealmCoopResult {
//    var goldenIkuraNumPerWave: Double? {
//        if self.waves.count == .zero {
//            return nil
//        }
//        return Double(self.goldenIkuraNum) * 3 / Double(self.waves.count)
//    }
//
//    var ikuraNumPerWave: Double? {
//        if self.waves.count == .zero {
//            return nil
//        }
//        return Double(self.ikuraNum) * 3 / Double(self.waves.count)
//    }
//
//    var bossKillCountsTotalPerWave: Double? {
//        if self.waves.count == .zero {
//            return nil
//        }
//        return Double(self.bossKillCounts.sum()) * 3 / Double(self.waves.count)
//    }
//}
//
//
//extension Array where Element: Numeric  {
//    func add<T: Numeric>(_ input: Array<T>) -> Array<T> {
//        return zip(self as! [T], input).map({ $0.0 + $0.1 })
//    }
//}
//
//func sum<T: Numeric>(of arrays: Array<Array<T>>) -> Array<T> {
//    if let first = arrays.first {
//        var sum: [T] = Array(repeating: 0, count: first.count)
//        let _ = arrays.map({ sum = sum.add($0) })
//        return sum
//    }
//    return []
//}
//
//extension WeaponType {
//    static var randoms: Set<WeaponType> {
//        Set(WeaponType.allCases.filter({ $0.rawValue >= 0 && $0.rawValue <= 20000  }))
//    }
//}
