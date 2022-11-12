//
//  WeaponType.swift
//  Salmonia3+
//
//  Created by devonly on 2022/11/12.
//

import Foundation
import SplatNet3

extension WeaponType {
    static var randoms: Set<WeaponType> {
        Set(WeaponType.allCases.filter({ $0.rawValue >= 0 && $0.rawValue <= 20000  }))
    }
}
