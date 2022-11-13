//
//  RealmSwift+Results.swift
//  Salmonia3+
//
//  Created by devonly on 2022/11/12.
//

import Foundation
import SplatNet3
import RealmSwift

extension RealmSwift.Results where Element == RealmCoopPlayer {
    typealias Entry = Grizzco.Entry

    var weaponEntries: [Entry<WeaponType>] {
        let weaponList: [WeaponType] = flatMap({ $0.weaponList })
        let randoms: Set<WeaponType> = Set(weaponList).union(WeaponType.randoms)
        return randoms
            .map({ weaponId in
                weaponList.count(weaponId)
            })
            .map({ weaponId, count in
                Entry<WeaponType>(
                    key: weaponId,
                    count: count,
                    percent: weaponList.count == .zero ? nil : Double(count) / Double(weaponList.count)
                )
            })
    }

    var specialEntries: [Entry<SpecialType>] {
        let specialList: [SpecialType] = Array(SpecialType.allCases.dropFirst())
        let suppliedSpecials: [SpecialType] = self.compactMap({ $0.specialId })
        if suppliedSpecials.count == .zero {
            return specialList
                .map({ suppliedSpecials.count($0) })
                .map({
                    Entry(key: $0.element, count: 0, percent: nil)
                })
        }
        return specialList
            .map({
                suppliedSpecials.count($0)
            })
            .map({
                Entry(key: $0.element, count: $0.count, percent: Double($0.count) / Double(suppliedSpecials.count) * 100)
            })
    }
}

extension Array where Element == RealmCoopPlayer {
    func bossKillCounts() -> [Int] {
        map({ $0.bossKillCounts }).transposed().map({ $0.reduce(0, +) })
    }
}

extension RealmSwift.List where Element == RealmCoopResult {
    /// オオモノシャケの出現数合計
    func bossCounts() -> [Int] {
        return self.map({ $0.bossCounts }).transposed().map({ $0.reduce(0, +) })
    }

    /// オオモノシャケの討伐数合計
    func bossKillCounts() -> [Int] {
        return self.map({ $0.bossKillCounts }).transposed().map({ $0.reduce(0, +) })
    }

    /// オオモノシャケの討伐数合計
    func bossKillCounts(isMyself: Bool) -> [Int] {
        /// 個人を取得
        let players: [RealmCoopPlayer] = self.compactMap({ $0.players.first(where: { $0.isMyself }) })

        switch isMyself {
        case true:
            /// 個人の成績をそのまま返す
            return players.bossKillCounts()
        case false:
            return bossKillCounts().sub(players.bossKillCounts()).map({ $0 / 3 })
        }
    }

    func asBossDefeatedEntries(isMyself: Bool) -> [BarChartEntry] {
        let bossKillCounts: [Double] = bossKillCounts(isMyself: isMyself).div(bossCounts())
        return zip(SakelienType.allCases.dropLast(1), bossKillCounts).map({ id, value -> BarChartEntry in
            BarChartEntry(x: id, y: value, isMyself: isMyself)
        })
    }
}

extension Array where Element: Numeric {
    func sub<T: Numeric>(_ input: Array<T>) -> Array<T> {
        return zip(self as! [T], input).map({ $0.0 - $0.1 })
    }

    func add<T: Numeric>(_ input: Array<T>) -> Array<T> {
        return zip(self as! [T], input).map({ $0.0 + $0.1 })
    }

    func div<T: BinaryInteger>(_ by: Array<T>) -> Array<Double> {
        return zip(self as! [T], by).map({ $0.1 == .zero ? .zero : Double($0.0) / Double($0.1) })
    }
}
