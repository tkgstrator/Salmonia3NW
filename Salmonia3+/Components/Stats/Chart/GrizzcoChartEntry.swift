//
//  GrizzcoChartEntry.swift
//  Salmonia3+
//
//  Created by tkgstrator on 2022/10/30.
//

import Foundation
import RealmSwift
import SplatNet3

public enum Grizzco {
    public class ChartEntrySet: ObservableObject, Identifiable {
        @Published var title: LocalizedType = .CoopHistory_Title
        @Published var data: [ChartEntry] = []

        func average() -> Double {
            self.data.compactMap({ $0.value }).reduce(0, +) / Double(data.count)
        }

        func max() -> Double {
            self.data.compactMap({ $0.value }).max(by: { $0 < $1 }) ?? .zero
        }

        func min() -> Double {
            self.data.compactMap({ $0.value }).min(by: { $0 < $1 }) ?? .zero
        }

        init(title: LocalizedType) {
            self.title = title
            self.data = (0...20).map({ ChartEntry(count: $0, value: Double.random(in: 0...15))})
        }

        init(title: LocalizedType, data: [ChartEntry]) {
            self.title = title
            self.data = data
        }
    }

    public struct ChartEntry: Identifiable {
        public let id: UUID = UUID()
        let count: Int
        let value: Double

        init<T: BinaryInteger>(count: Int, value: T) {
            self.count = count
            self.value = Double(value)
        }

        init<T: BinaryFloatingPoint>(count: Int, value: T) {
            self.count = count
            self.value = Double(value)
        }
    }

    public enum Chart {
        class Average: ObservableObject {
            @Published var weaponList: [WeaponType] = []
            @Published var rareWeapon: WeaponType? = nil
            @Published var goldenIkuraNum: Double? = nil
            @Published var ikuraNum: Double? = nil
            @Published var helpCount: Double? = nil
            @Published var deadCount: Double? = nil

            init() {}

            init(schedule: RealmCoopSchedule, players: RealmSwift.Results<RealmCoopPlayer>) {
                self.weaponList = Array(schedule.weaponList)
                self.rareWeapon = schedule.results.rareWeapon
                self.goldenIkuraNum = players.average(ofProperty: "goldenIkuraNum")
                self.ikuraNum = players.average(ofProperty: "ikuraNum")
                self.helpCount = players.average(ofProperty: "helpCount")
                self.deadCount = players.average(ofProperty: "deadCount")
            }
        }

        class Point: ObservableObject {
            @Published var playCount: Int? = nil
            @Published var goldenIkuraNum: Int? = nil
            @Published var ikuraNum: Int? = nil
            @Published var bossKillCount: Int? = nil
            @Published var regularPoint: Int? = nil
            @Published var helpCount: Int? = nil
            @Published var charts: [Grizzco.ChartEntrySet] = []

            init() {}

            init(results: RealmSwift.List<RealmCoopResult>, players: RealmSwift.Results<RealmCoopPlayer>) {
                if results.count == .zero { return }
                self.playCount = results.count
                self.goldenIkuraNum = results.sum(ofProperty: "goldenIkuraNum")
                self.ikuraNum = results.sum(ofProperty: "ikuraNum")
                self.bossKillCount = results.filter({ $0.isBossDefeated == true }).count
                self.regularPoint = results.sum(ofProperty: "kumaPoint")
                self.helpCount = players.sum(ofProperty: "helpCount")
                self.charts = [
                    results.map({ $0.dangerRate * 100 }).asLineChartEntry(id: .CoopHistory_DangerRatio)
                ]
            }
        }

        class Maximum: ObservableObject {
            @Published var maxGrade: GradeType? = nil
            @Published var maxGradePoint: Int? = nil
            @Published var averageWaveCleared: Double? = nil
            @Published var charts: [Grizzco.ChartEntrySet] = []

            init() {}

            init(results: RealmSwift.List<RealmCoopResult>) {
                if results.count == .zero { return }
                guard let maxGrade: GradeType = results.max(ofProperty: "grade") else { return }
                self.maxGrade = maxGrade
                self.maxGradePoint = results.filter("grade=%@", maxGrade).max(ofProperty: "gradePoint")
                self.averageWaveCleared = results.averageWaveCleared
                self.charts = [
                    results.compactMap({ $0.dangerRate == .zero ? nil : $0.gradePoint }).asLineChartEntry(id: .CoopHistory_JobRatio),
                    results.compactMap({ $0.gradePointCrew }).asLineChartEntry(id: .CoopHistory_Score)
                ]
            }
        }

        class Scale: ObservableObject {
            @Published var gold: Int? = nil
            @Published var silver: Int? = nil
            @Published var bronze: Int? = nil

            init() {}

            init(results: RealmSwift.List<RealmCoopResult>) {
                if results.count == .zero { return }
                var scales: [Int] = results.scalesCount
                self.bronze = scales.removeFirst()
                self.silver = scales.removeFirst()
                self.gold = scales.removeFirst()
            }
        }

        class Weapons: ObservableObject {
            /// 支給されたブキの数
            @Published var suppliedWeaponCount: Int?
            /// 推定コンプリート回数
            @Published var estimateCompleteCount: Int?
            /// データ
            @Published var entries: [Entry] = []
            /// ランダム編成かどうか
            @Published var isRandom: Bool = false

            init() {}

            init(schedule: RealmCoopSchedule, players: RealmSwift.Results<RealmCoopPlayer>) {
                self.isRandom = schedule.weaponList.contains(.Random_Green)
                self.suppliedWeaponCount = players.suppliedWeapons.count
                self.entries = self.isRandom ? [] : players.suppliedWeaponEntry
            }

            struct Entry: Identifiable {
                let id: WeaponType
                let count: Int?
                let percent: Double?

                init(id: WeaponType, count: Int? = nil, percent: Double? = nil) {
                    self.id = id
                    self.count = count
                    self.percent = percent
                }
            }
        }

        class SpecialWeapons: ObservableObject {
            @Published var entries: [Entry] = []

            init() {}

            init(players: RealmSwift.Results<RealmCoopPlayer>) {
                self.entries = players.suppliedSpecialEntry
            }

            struct Entry: Identifiable {
                let id: SpecialType
                let count: Int?
                let percent: Double?

                init(id: SpecialType, count: Int? = nil, percent: Double? = nil) {
                    self.id = id
                    self.count = count
                    self.percent = percent
                }
            }
        }

        class Sakelien: ObservableObject {
            @Published var series: [SakelienEntry] = []

            struct SakelienEntry: Identifiable {
                let id: SakelienType
                let bossCount: Int?
                let bossKillCount: Int?
                let bossTeamKillCount: Int?
            }
        }

        public class Values: ObservableObject {
            @Published var goldenIkuraNum: [ValueEntry] = []
            @Published var ikuraNum: [ValueEntry] = []
            @Published var helpCount: [ValueEntry] = []
            @Published var deadCount: [ValueEntry] = []

            init() {}

            init(results: RealmSwift.List<RealmCoopResult>, players: RealmSwift.Results<RealmCoopPlayer>) {
                self.goldenIkuraNum = [
                    ValueEntry(
                        title: .CoopHistory_GoldenDeliverCount,
                        id: .Solo,
                        icon: .GoldenIkura,
                        values: players.map({ $0.goldenIkuraNum }),
                        waves: players.map({ $0.goldenIkuraNumPerWave })
                    ),
                    ValueEntry(
                        title: .CoopHistory_GoldenDeliverCount,
                        id: .Team,
                        icon: .GoldenIkura,
                        values: results.map({ $0.goldenIkuraNum }),
                        waves: results.map({ $0.goldenIkuraNumPerWave }))
                ]
                self.ikuraNum = [
                    ValueEntry(
                        title: .CoopHistory_DeliverCount,
                        id: .Solo,
                        icon: .Ikura,
                        values: players.map({ $0.ikuraNum }),
                        waves: players.map({ $0.ikuraNumPerWave })),
                    ValueEntry(
                        title: .CoopHistory_DeliverCount,
                        id: .Team,
                        icon: .Ikura,
                        values: results.map({ $0.ikuraNum }),
                        waves: results.map({ $0.ikuraNumPerWave }))
                ]
                self.helpCount = [
                    ValueEntry(
                        title: .CoopHistory_RescueCount,
                        id: .Solo,
                        icon: .Ikura,
                        values: players.map({ $0.helpCount }))
                ]
                self.deadCount = [
                    ValueEntry(
                        title: .CoopHistory_RescuedCount,
                        id: .Solo,
                        icon: .Ikura,
                        values: players.map({ $0.deadCount }))
                ]
            }

            public class ValueEntry: ObservableObject, Identifiable {
                @Published public var id: UUID = UUID()
                @Published var type: ChartType = .Solo
                @Published var icon: ChartIconType = .GoldenIkura
                @Published var maxValue: Int? = nil
                @Published var avgValue: Double? = nil
                @Published var charts: Grizzco.ChartEntrySet

                init<T: BinaryInteger, S: BinaryFloatingPoint>(title: LocalizedType, id: ChartType, icon: ChartIconType, values: [T?], waves: [S?] = []) {
                    self.type = id
                    self.icon = icon
                    self.maxValue = {
                        if let maxValue = values.compactMap({ $0 }).max() {
                            return Int(maxValue)
                        }
                        return nil
                    }()
                    let values: [S] = waves.compactMap({ $0 })
                    self.avgValue = {
                        if values.isEmpty { return nil }
                        return values.map({ Double($0) }).reduce(0, +) / Double(values.count)
                    }()
                    self.charts = values.asLineChartEntry(id: title)
                }

                init<T: BinaryInteger>(title: LocalizedType, id: ChartType, icon: ChartIconType, values: [T?]) {
                    self.type = id
                    self.icon = icon
                    let values: [T] = values.compactMap({ $0 })
                    self.maxValue = {
                        if let maxValue = values.compactMap({ $0 }).max() {
                            return Int(maxValue)
                        }
                        return nil
                    }()
                    self.avgValue = {
                        if values.isEmpty { return nil }
                        return values.map({ Double($0) }).reduce(0, +) / Double(values.count)
                    }()
                    self.charts = values.asLineChartEntry(id: title)
                }
            }
        }

        class Wave: ObservableObject {
            @Published var highTide: [WaveEntry] = []
            @Published var normalTide: [WaveEntry] = []
            @Published var lowTide: [WaveEntry] = []

            struct WaveEntry: Identifiable {
                var id: Int { eventType.hashValue &+ waterLevel.hashValue }
                let eventType: EventType = .Water_Levels
                let waterLevel: WaterType = .Middle_Tide
                let count: Int?
                let goldenIkuraMax: Int?
                let goldenIkuraAvg: Double?
                let clearRation: Double?
            }

            init() {}
        }
    }
}

extension RealmSwift.Results where Element == RealmCoopResult {
}

extension RealmSwift.List where Element == RealmCoopResult {
    fileprivate var scalesCount: [Int] {
        self.map({ Array($0.scale) }).transposed().map({ $0.compactMap({ $0 }).reduce(0, +) })
    }

    fileprivate var rareWeapon: WeaponType? {
        self.flatMap({ $0.players.flatMap({ $0.weaponList }) }).first(where: { $0.rawValue >= 20000 })
    }

    fileprivate var averageWaveCleared: Double? {
        if self.count == .zero { return nil }
        let failureWaveTotal: Int = self.compactMap({ $0.failureWave }).map({ 4 - $0 }).reduce(0, +)
        return 3.0 - Double(failureWaveTotal) / Double(self.count)
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

extension RealmSwift.Results where Element == RealmCoopPlayer {
    typealias WeaponEntry = Grizzco.Chart.Weapons.Entry
    typealias SpecialEntry = Grizzco.Chart.SpecialWeapons.Entry

    fileprivate var suppliedWeapons: Set<WeaponType> {
        Set(self.flatMap({ Array($0.weaponList) }))
    }

    fileprivate var suppliedWeaponEntry: [WeaponEntry] {
        let suppliedWeapons: [WeaponType] = self.flatMap({ Array($0.weaponList) })
        let count: Int = suppliedWeapons.count
        return suppliedWeapons.count().map({
            WeaponEntry(
                id: $0.element,
                count: $0.count,
                percent:  $0.count == .zero ? nil : Double($0.count) / Double(count) * 100)
        })
    }

    fileprivate var suppliedSpecialEntry: [SpecialEntry] {
        let specialList: [SpecialType] = Array(SpecialType.allCases.dropFirst())
        let suppliedSpecials: [SpecialType] = self.compactMap({ $0.specialId })
        if suppliedSpecials.count == .zero {
            return specialList.map({ suppliedSpecials.count($0) }).map({ SpecialEntry(id: $0.element, count: nil, percent: nil) })
        }
        return specialList.map({ suppliedSpecials.count($0) }).map({ SpecialEntry(id: $0.element, count: $0.count, percent: Double($0.count) / Double(suppliedSpecials.count) * 100) })
    }
}

extension Array where Element: BinaryFloatingPoint {
    func asLineChartEntry(id: LocalizedType) -> Grizzco.ChartEntrySet {
        Grizzco.ChartEntrySet(title: id, data: self.enumerated().map({ Grizzco.ChartEntry(count: $0.offset, value: $0.element) }))
    }
}

extension Array where Element: BinaryInteger {
    func asLineChartEntry(id: LocalizedType) -> Grizzco.ChartEntrySet {
        Grizzco.ChartEntrySet(title: id, data: self.enumerated().map({ Grizzco.ChartEntry(count: $0.offset, value: $0.element) }))
    }
}

extension RealmCoopPlayer {
    var goldenIkuraNumPerWave: Double? {
        if self.specialCounts.count == .zero {
            return nil
        }
        return Double(self.goldenIkuraNum) * 3 / Double(self.specialCounts.count)
    }

    var ikuraNumPerWave: Double? {
        if self.specialCounts.count == .zero {
            return nil
        }
        return Double(self.ikuraNum) * 3 / Double(self.specialCounts.count)
    }
}

extension RealmCoopResult {
    var goldenIkuraNumPerWave: Double? {
        if self.waves.count == .zero {
            return nil
        }
        return Double(self.goldenIkuraNum) * 3 / Double(self.waves.count)
    }

    var ikuraNumPerWave: Double? {
        if self.waves.count == .zero {
            return nil
        }
        return Double(self.ikuraNum) * 3 / Double(self.waves.count)
    }
}

extension RealmCoopResult {
    var gradePointCrew: Double? {
        guard let grade = self.grade,
              let gradePoint = self.gradePoint else {
            return nil
        }
        if self.dangerRate == .zero {
            return nil
        }
        return (self.dangerRate * 100 * 5 * 4 - Double(grade.rawValue * 100 + gradePoint)) / 3 - Double(grade.rawValue * 100)
    }
}
