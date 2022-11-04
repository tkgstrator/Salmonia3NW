//
//  RealmCoopSchedule.swift
//  Salmonia3+
//
//  Created by tkgstrator on 2022/09/16.
//

import Foundation
import RealmSwift
import SplatNet3

class RealmCoopSchedule: Object {
    @Persisted(indexed: true) var startTime: Date?
    @Persisted(indexed: true) var endTime: Date?
    @Persisted var stageId: StageType
    @Persisted var weaponList: List<WeaponType>
    @Persisted var results: List<RealmCoopResult>
    @Persisted var rareWeapon: WeaponType?
    @Persisted var rule: Common.Rule
    @Persisted var mode: Common.Mode

    convenience init(from schedule: CoopSchedule.Response) {
        self.init()
        self.startTime = schedule.startTime
        self.endTime = schedule.endTime
        self.stageId = schedule.stageId
        self.weaponList.append(objectsIn: schedule.weaponList)
        self.rareWeapon = nil
        self.rule = schedule.rule
        self.mode = schedule.mode
    }

    convenience init(from result: SplatNet2.Result) {
        let dateFormatter: ISO8601DateFormatter = {
            let formatter: ISO8601DateFormatter = ISO8601DateFormatter()
            formatter.timeZone = TimeZone.current
            return formatter
        }()
        self.init()
        self.startTime = {
            if let startTime = result.schedule.startTime {
                return dateFormatter.date(from: startTime)
            }
            return nil
        }()
        self.endTime = {
            if let endTime = result.schedule.endTime {
                return dateFormatter.date(from: endTime)
            }
            return nil
        }()
        self.stageId = result.schedule.stage
        self.weaponList.append(objectsIn: result.schedule.weaponLists)
        self.rule = result.schedule.rule
        self.mode = result.schedule.mode
        self.rareWeapon = nil
    }

    convenience init(dummy: Bool = true) {
        self.init()
        self.stageId = StageType.Shakespiral
        self.weaponList.append(objectsIn: Array(repeating: WeaponType.Saber_Normal, count: 4))
        self.results.append(RealmCoopResult(dummy: true))
        self.rule = Common.Rule.REGULAR
        self.rareWeapon = nil
    }
}

extension RealmCoopSchedule: Identifiable {
    public var id: Int {
        /// いつものバイト
        if let startTime: Date = self.startTime {
            return startTime.hashValue
        }
        /// プライベートバイト
        return self.hashValue
    }
}

extension RealmCoopSchedule {
    /// 同じシフトであるとの判定条件
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

    /// 同じシフトであるとの判定条件
    static func == (lhs: RealmCoopSchedule, rhs: RealmCoopSchedule) -> Bool {
        /// ステージが同じ
        lhs.stageId == rhs.stageId &&
        /// ルールが同じ
        lhs.rule == rhs.rule &&
        /// モードが同じ
        lhs.mode == rhs.mode &&
        /// 支給されたブキが同じ
        Array(lhs.weaponList) == Array(rhs.weaponList) &&
        /// 開始時刻が同じ
        lhs.startTime == rhs.startTime &&
        /// 終了時刻が同じ
        lhs.endTime == rhs.endTime
    }
}

extension Common.Rule: PersistableEnum {}

extension Common.Mode: PersistableEnum {}
