//
//  GrizzcoChartEntry.swift
//  Salmonia3+
//
//  Created by devonly on 2022/10/30.
//

import Foundation
import RealmSwift
import SplatNet3

enum Grizzco {
    class LineChartEntry: ObservableObject, Identifiable {
        @Published var id: LocalizedType
        @Published var data: [ChartEntry]

        init(id: LocalizedType) {
            self.id = id
            self.data = (0...20).map({ ChartEntry(count: $0, value: Double.random(in: 0...15))})
        }

        init(id: LocalizedType, data: [ChartEntry]) {
            self.id = id
            self.data = data
        }
    }

    struct ChartEntry: Identifiable {
        let id: UUID = UUID()
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

    enum Chart {
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

            init() {}

            init(results: RealmSwift.List<RealmCoopResult>, players: RealmSwift.Results<RealmCoopPlayer>) {
                if results.count == .zero { return }
                self.playCount = results.count
                self.goldenIkuraNum = results.sum(ofProperty: "goldenIkuraNum")
                self.ikuraNum = results.sum(ofProperty: "ikuraNum")
                self.bossKillCount = results.filter({ $0.isBossDefeated == true }).count
                self.regularPoint = results.sum(ofProperty: "kumaPoint")
                self.helpCount = players.sum(ofProperty: "helpCount")
            }
        }

        class Maximum: ObservableObject {
            @Published var maxGrade: GradeType? = nil
            @Published var maxGradePoint: Int? = nil
            @Published var averageWaveCleared: Double? = nil

            init() {}

            init(results: RealmSwift.List<RealmCoopResult>) {
                if results.count == .zero { return }
                guard let maxGrade: GradeType = results.max(ofProperty: "grade") else { return }
                self.maxGrade = maxGrade
                self.maxGradePoint = results.filter("grade=%@", maxGrade).max(ofProperty: "gradePoint")
                self.averageWaveCleared = results.averageWaveCleared
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
                let count: Int? = nil
                let percent: Double? = nil
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

        class Values: ObservableObject {
            @Published var entries: [ValueEntry] = []

            struct ValueEntry {
                let id: ChartType = .Solo
                let maxValue: Int? = nil
                let avgValue: Double? = nil
                let charts: [LineChartEntry]
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
        return suppliedWeapons.count().map({ WeaponEntry(id: $0.element) })
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
