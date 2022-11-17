//
//  RealmSwift+List.swift
//  Salmonia3+
//
//  Created by devonly on 2022/11/12.
//

import Foundation
import SplatNet3
import RealmSwift

extension RealmSwift.List where Element == RealmCoopResult {
    var scalesCount: [Int] {
        self.map({ Array($0.scale) }).transposed().map({ $0.compactMap({ $0 }).reduce(0, +) })
    }

    var rareWeapon: WeaponType? {
        self.flatMap({ $0.players.flatMap({ $0.weaponList }) }).first(where: { $0.rawValue >= 20000 })
    }

    /// 平均クリアWAVE
    var averageWaveCleared: Double? {
        if self.count == .zero { return nil }
        let failureWaveTotal: Int = self.compactMap({ $0.failureWave }).map({ 4 - $0 }).reduce(0, +)
        return 3.0 - Double(failureWaveTotal) / Double(self.count)
    }

    /// WAVEあたりのイクラ数
    func ikuraNum(isMyself: Bool) -> [Double] {
        /// キケン度が0%のリザルトは無視する
        let results: RealmSwift.Results<RealmCoopResult> = self.filter("dangerRate!=%@", Double.zero)

        switch isMyself {
        case true:
            /// 個人のイクラ数を取得
            return results.compactMap({ result -> Double? in
                guard let ikuraNum: Int = result.players.first(where: { $0.isMyself })?.ikuraNum else {
                    return nil
                }
                return Double(ikuraNum) / Double(result.waves.count) * 3.0
            })
        case false:
            /// 仲間のイクラ数を取得
            return results.compactMap({ result -> Double? in
                guard let ikuraNum: Int = result.players.first(where: { $0.isMyself })?.ikuraNum else {
                    return nil
                }
                return Double(result.ikuraNum - ikuraNum) / Double(result.players.filter({ !$0.isMyself }).flatMap({ $0.weaponList }).count) * 3.0
            })
        }
    }

    /// WAVEあたりの金イクラ納品数
    func goldenIkuraNum(isMyself: Bool) -> [Double] {
        /// キケン度が0%のリザルトは無視する
        let results: RealmSwift.Results<RealmCoopResult> = self.filter("dangerRate!=%@", Double.zero)

        switch isMyself {
        case true:
            /// 個人のイクラ数を取得
            return results.compactMap({ result -> Double? in
                guard let goldenIkuraNum: Int = result.players.first(where: { $0.isMyself })?.goldenIkuraNum else {
                    return nil
                }
                return Double(goldenIkuraNum) / Double(Swift.min(3, result.waves.count)) * 3.0
            })
        case false:
            /// 仲間のイクラ数を取得
            return results.compactMap({ result -> Double? in
                guard let goldenIkuraNum: Int = result.players.first(where: { $0.isMyself })?.goldenIkuraNum else {
                    return nil
                }
                return Double(result.goldenIkuraNum - goldenIkuraNum) / Double(result.players.filter({ !$0.isMyself }).map({ Swift.min(3, $0.weaponList.count) }).reduce(0, +) ) * 3.0
            })
        }
    }

    /// WAVEがあたりのイクラ納品数
    func teamIkuraNum() -> [Double] {
        /// キケン度が0%のリザルトは無視する
        let results: RealmSwift.Results<RealmCoopResult> = self.filter("dangerRate!=%@", Double.zero)

        return results.map({ Double($0.ikuraNum) / Double($0.waves.count) * 3.0 })
    }

    /// WAVEがあたりの金イクラ納品数
    func teamGoldenIkuraNum() -> [Double] {
        /// キケン度が0%のリザルトは無視する
        let results: RealmSwift.Results<RealmCoopResult> = self.filter("dangerRate!=%@", Double.zero)

        return results.map({ Double($0.goldenIkuraNum) / Double(Swift.min(3, $0.waves.count)) * 3.0 })
    }

    func defeatedNum(isMyself: Bool) -> [Double] {
        /// キケン度が0%のリザルトは無視する
        let results: RealmSwift.Results<RealmCoopResult> = self.filter("dangerRate!=%@", Double.zero)
        let bossKillCounts: [Int] = results.compactMap({ $0.players.first(where: { $0.isMyself })?.bossKillCountsTotal })

        switch isMyself {
        case true:
            return bossKillCounts.map({ Double($0) })
        case false:
            return results.map({ Double($0.bossKillCounts.sum() - ($0.players.first(where: { $0.isMyself })?.bossKillCountsTotal ?? 0)) / 3.0 })
        }
    }

    func teamDefeatedNum() -> [Double] {
        /// キケン度が0%のリザルトは無視する
        let results: RealmSwift.Results<RealmCoopResult> = self.filter("dangerRate!=%@", Double.zero)

        return results.map({ Double($0.bossKillCounts.sum()) / Double($0.waves.count) * 3.0 })
    }

    func ikuraNumRate(isMyself: Bool) -> [PlotChartEntry] {
        /// キケン度が0%のリザルトは無視する
        let results: RealmSwift.Results<RealmCoopResult> = self.filter("dangerRate!=%@", Double.zero)
        let players: [RealmCoopPlayer] = {
            switch isMyself {
            case true:
                return results.compactMap({ $0.players.first(where: { $0.isMyself }) })
            case false:
                return results.flatMap({ $0.players.filter({ !$0.isMyself })})
            }
        }()

        return results.flatMap({ result -> [PlotChartEntry] in
            guard let gradePoint: Int = result.gradePoint,
                  let grade: GradeType = result.grade,
                  let gradePointCrew: Double = result.gradePointCrew
            else {
                return []
            }

            return result.players.map({ player -> PlotChartEntry in
                let gradePoint: Int = {
                    if player.isMyself {
                        return grade.rawValue * 100 + gradePoint
                    }
                    return (Int(gradePointCrew) / 5) * 5 + grade.rawValue * 100
                }()
                return PlotChartEntry(x: gradePoint, y: Double(player.ikuraNum) / Double(result.ikuraNum) * 100, isClear: player.isMyself)
            })
        })
    }
}
