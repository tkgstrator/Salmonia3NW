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
}
