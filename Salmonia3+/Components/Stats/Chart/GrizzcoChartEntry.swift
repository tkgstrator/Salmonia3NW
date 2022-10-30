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
    enum ChartEntry {
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

            init(results: RealmSwift.List<RealmCoopResult>) {
                if results.count == .zero { return }
                self.playCount = results.count
                self.goldenIkuraNum = results.sum(ofProperty: "goldenIkuraNum")
                self.ikuraNum = results.sum(ofProperty: "ikuraNum")
                self.bossKillCount = results.filter({ $0.isBossDefeated == true }).count
                self.regularPoint = results.sum(ofProperty: "kumaPoint")
                self.helpCount = results.sum(ofProperty: "helpCount")
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
            @Published var entries: [WeaponEntry] = []

            struct WeaponEntry: Identifiable {
                let id: WeaponType
                let count: Int? = nil
                let percent: Double? = nil
            }
        }

        class SpecialWeapons: ObservableObject {
            @Published var entries: [WeaponEntry] = []

            init() {}
            
            struct WeaponEntry: Identifiable {
                let id: WeaponType
                let count: Int? = nil
                let percent: Double? = nil
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

        class Player: ObservableObject {
            @Published var maxValue: Int? = nil
            @Published var avgValue: Double? = nil
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

extension RealmSwift.Results where Element == RealmCoopPlayer {
    fileprivate var suppliedWeapons: Set<WeaponType> {
        Set(self.flatMap({ Array($0.weaponList) }))
    }
}
