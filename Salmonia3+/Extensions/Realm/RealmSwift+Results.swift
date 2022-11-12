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
