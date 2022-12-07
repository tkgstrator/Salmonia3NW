//
//  SHA256Hash.swift
//  Salmonia3+
//  
//  Created by devonly on 2022/12/03
//  Copyright © 2022 Magi Corporation. All rights reserved.
//

import Foundation
import CryptoKit
import SplatNet3

extension SHA256 {
    static func hash<T: LosslessStringConvertible>(_ value: T) -> String {
        return SHA256
            .hash(data: String(value).data(using: .utf8)!)
            .compactMap({ String(format: "%02x", $0) })
            .joined()
    }

    static func resultHash(startTime: Date) -> String {
        return SHA256.hash(startTime.description)
    }

    static func resultHash(stageId: Int, rule: String, mode: String, weaponList: [Int]) -> String {
        let hashes: [String] = [
            SHA256.hash(stageId),
            SHA256.hash(rule),
            SHA256.hash(mode)
        ] + weaponList.map({ SHA256.hash($0) })
        return SHA256.hash(hashes.joined())
    }

    static func resultHash(stageId: CoopStageId, rule: RuleType, mode: ModeType, weaponList: [WeaponId]) -> String {
        resultHash(stageId: stageId.rawValue, rule: rule.rawValue, mode: mode.rawValue, weaponList: weaponList.map({ $0.rawValue }))
    }
}
