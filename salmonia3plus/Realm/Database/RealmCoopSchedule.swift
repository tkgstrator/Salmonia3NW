//
//  RealmCoopSchedule.swift
//  SplatNetDemo
//
//  Created by devonly on 2022/11/27.
//

import Foundation
import RealmSwift
import SplatNet3
import CryptoKit

class RealmCoopSchedule: Object, Codable, Identifiable {
    @Persisted(primaryKey: true) var id: String
    @Persisted(indexed: true) var startTime: Date?
    @Persisted(indexed: true) var endTime: Date?
    @Persisted var stageId: CoopStageId
    @Persisted var weaponList: List<WeaponId>
    @Persisted var results: List<RealmCoopResult>
    @Persisted var rareWeapon: WeaponId?
    @Persisted var rule: RuleType
    @Persisted var mode: ModeType
    @Persisted var bossCounts: List<Int> = List<Int>(contentsOf: Array(repeating: 0, count: 15))
    @Persisted var bossKillCounts: List<Int> = List<Int>(contentsOf: Array(repeating: 0, count: 15))
    @Persisted var bossTeamCounts: List<Int> = List<Int>(contentsOf: Array(repeating: 0, count: 15))

    override init() {
        super.init()
    }

    convenience init(content: CoopSchedule) {
        self.init()
        self.id = content.startTime.hash
        self.startTime = content.startTime
        self.endTime = content.endTime
        self.stageId = content.stageId
        self.weaponList.append(objectsIn: content.weaponList)
        self.rareWeapon = nil
        self.rule = content.rule
        self.mode = content.mode
    }

    convenience init(content: CoopResult.Schedule) {
        self.init()
        self.id = {
            if let startTime = content.startTime {
                return startTime.hash
            }
            return content.hash
        }()
        self.startTime = content.startTime
        self.endTime = content.endTime
        self.stageId = content.stageId
        self.weaponList.append(objectsIn: content.weaponList)
        self.rareWeapon = nil
        self.rule = content.rule
        self.mode = content.mode
    }

    enum CodingKeys: String, CodingKey {
        case id
        case startTime
        case endTime
        case stageId
        case weaponList
        case rareWeapon
        case rule
        case mode
        case results
        case bossCounts
        case bossKillCounts
        case bossTeamCounts
    }

    public required init(from decoder: Decoder) throws {
        super.init()
        
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.id = try container.decode(String.self, forKey: .id)
        self.startTime = try container.decodeIfPresent(Date.self, forKey: .startTime)
        self.endTime = try container.decodeIfPresent(Date.self, forKey: .endTime)
        self.stageId = try container.decode(CoopStageId.self, forKey: .stageId)
        self.weaponList.append(objectsIn: try container.decode([WeaponId].self, forKey: .weaponList))
        self.results.append(objectsIn: try container.decode([RealmCoopResult].self, forKey: .results))
        self.rareWeapon = try container.decodeIfPresent(WeaponId.self, forKey: .rareWeapon)
        self.rule = try container.decode(RuleType.self, forKey: .rule)
        self.mode = try container.decode(ModeType.self, forKey: .mode)
        self.bossCounts.append(objectsIn: try container.decode([Int].self, forKey: .bossCounts))
        self.bossKillCounts.append(objectsIn: try container.decode([Int].self, forKey: .bossKillCounts))
        self.bossTeamCounts.append(objectsIn: try container.decode([Int].self, forKey: .bossTeamCounts))
    }

    public func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)

        try container.encode(id, forKey: .id)
        try container.encode(startTime, forKey: .startTime)
        try container.encode(endTime, forKey: .endTime)
        try container.encode(stageId, forKey: .stageId)
        try container.encode(weaponList, forKey: .weaponList)
        try container.encode(rareWeapon, forKey: .rareWeapon)
        try container.encode(rule, forKey: .rule)
        try container.encode(mode, forKey: .mode)
        try container.encode(results, forKey: .results)
        try container.encode(bossCounts, forKey: .bossCounts)
        try container.encode(bossTeamCounts, forKey: .bossTeamCounts)
        try container.encode(bossKillCounts, forKey: .bossKillCounts)
    }
}

extension Date {
    var hash: String {
        return SHA256
            .hash(data: self.description.data(using: .utf8)!)
            .compactMap({ String(format: "%02x", $0) })
            .joined()
    }
}

fileprivate extension CoopResult.Schedule {
    var hash: String {
        SHA256.resultHash(stageId: self.stageId, rule: self.rule, mode: self.mode, weaponList: self.weaponList)
    }
}

extension RealmCoopSchedule {
    override func isEqual(_ object: Any?) -> Bool {
        if let target: RealmCoopSchedule = object as? RealmCoopSchedule {
            return self.stageId == target.stageId &&
            self.rule == target.rule &&
            self.mode == target.mode &&
            Array(self.weaponList) == Array(target.weaponList) &&
            self.startTime == target.startTime &&
            self.endTime == target.endTime
        }
        return false
    }
}

extension WeaponId: PersistableEnum {}

extension RuleType: PersistableEnum {}

extension ModeType: PersistableEnum {}

extension CoopStageId: PersistableEnum {}
