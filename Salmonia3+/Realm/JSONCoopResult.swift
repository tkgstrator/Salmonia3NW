//
//  JSONCoopResult.swift
//  Salmonia3+
//
//  Created by tkgstrator on 2022/10/18.
//

import Foundation
import SplatNet3
import CryptoKit

struct JSONCoopResult: Codable, Hashable {
    /// データの正当性を担保するためのハッシュ
    var hash: String?
    /// Salmon Stats ID
    let salmonId: Int?
    /// ID
    let id: String
    /// イクラ
    let ikuraNum: Int
    /// 金イクラ
    let goldenIkuraNum: Int
    /// 金イクラアシスト数
    let goldenIkuraAssistNum: Int
    /// キケン度
    let dangerRate: Decimal
    /// バイトリザルト
    let jobResult: JSONJobResult
    /// スケジュール
    let schedule: JSONSchedule
    /// WAVE記録
    let waves: [JSONWaveResult]
    /// プレイヤー記録
    let players: [JSONPlayerResult]
    /// ウロコ枚数
    let scale: [Int?]

    init(result: RealmCoopResult) {
        self.salmonId = result.salmonId
        self.id = result.id
        self.ikuraNum = result.ikuraNum
        self.goldenIkuraNum = result.goldenIkuraNum
        self.goldenIkuraAssistNum = result.goldenIkuraAssistNum
        self.dangerRate = Decimal(result.dangerRate)
        self.jobResult = JSONJobResult(result: result)
        self.schedule = JSONSchedule(schedule: result.schedule)
        self.waves = result.waves.map({ JSONWaveResult(wave: $0) })
        self.players = result.players.map({ JSONPlayerResult(result: result, player: $0) })
        self.scale = Array(result.scale)
        self.hash = self.calcHash()
    }
}

extension JSONCoopResult {
    func validate() -> Bool {
        return calcHash() == self.hash
    }

    func calcHash() -> String? {
        guard let data = try? self.asData() else {
            return nil
        }
        return SHA256.hash(data: data).compactMap({ String(format: "%02x", $0) }).joined()
    }
}

struct JSONJobResult: Codable, Hashable {
    let isClear: Bool
    let failureWave: Int?
    let isBossDefeated: Bool?

    init(result: RealmCoopResult) {
        self.isClear = result.isClear
        self.failureWave = result.failureWave
        self.isBossDefeated = result.isBossDefeated
    }
}

struct JSONSchedule: Codable, Hashable {
    let startTime: Date?
    let endTime: Date?
    let stageId: Int
    let weaponList: [Int]
    let rareWeapon: Int?
    let rule: Common.Rule
    let mode: Common.Mode

    init(schedule: RealmCoopSchedule) {
        self.startTime = schedule.startTime
        self.endTime = schedule.endTime
        self.stageId = schedule.stageId.rawValue
        self.weaponList = schedule.weaponList.map({ $0.rawValue })
        self.rareWeapon = schedule.rareWeapon?.rawValue
        self.rule = schedule.rule
        self.mode = schedule.mode
    }
}

struct JSONWaveResult: Codable, Hashable {
    let id: Int
    let waterLevel: Int
    let eventType: Int
    let goldenIkuraNum: Int?
    let quotaNum: Int?
    let goldenIkuraPopNum: Int

    init(wave: RealmCoopWave) {
        self.id = wave.id
        self.waterLevel = wave.waterLevel.rawValue
        self.eventType = wave.eventType.rawValue
        self.goldenIkuraNum = wave.goldenIkuraNum
        self.quotaNum = wave.quotaNum
        self.goldenIkuraPopNum = wave.goldenIkuraPopNum
    }
}

struct JSONPlayerResult: Codable, Hashable {
    let id: String
    let pid: String
    let name: String
    let nameId: String
    let byname: String
    let isMyself: Bool
    let deadCount: Int
    let helpCount: Int
    let ikuraNum: Int
    let goldenIkuraNum: Int
    let goldenIkuraAssistNum: Int
    let specialId: Int?
    let bossKillCountsTotal: Int
    let bossKillCounts: [Int]
    let specialCounts: [Int]
    let badges: [BadgeType?]
    let background: NamePlateType
    let weaponList: [Int]
    /// バイトレート
    let jobRate: Decimal?
    /// バイトスコア
    let jobScore: Int?
    /// クマサンポイント
    let kumaPoint: Int?
    /// ジョブボーナス
    let jobBonus: Int?
    /// オカシラメーター
    let smellMeter: Int?
    /// 評価ポイント
    let gradePoint: Int?
    /// 称号
    let grade: GradeType?
    let species: SpeciesType

    init(result: RealmCoopResult, player: RealmCoopPlayer) {
        self.id = player.id
        self.pid = player.pid
        self.name = player.name
        self.nameId = player.nameId
        self.byname = player.byname
        self.isMyself = player.isMyself
        self.deadCount = player.deadCount
        self.helpCount = player.helpCount
        self.ikuraNum = player.ikuraNum
        self.goldenIkuraNum = player.goldenIkuraNum
        self.goldenIkuraAssistNum = player.goldenIkuraAssistNum
        self.specialId = player.specialId?.rawValue
        self.bossKillCounts = Array(player.bossKillCounts)
        self.bossKillCountsTotal = player.bossKillCountsTotal
        self.specialCounts = Array(player.specialCounts)
        self.badges = Array(player.badges)
        self.background = player.background
        self.weaponList = player.weaponList.map({ $0.rawValue })
        self.jobRate = player.isMyself ? Decimal(result.jobRate) : nil
        self.jobScore = player.isMyself ? result.jobScore : nil
        self.kumaPoint = player.isMyself ? result.kumaPoint : nil
        self.jobBonus = player.isMyself ? result.jobBonus : nil
        self.smellMeter = player.isMyself ? result.smellMeter : nil
        self.gradePoint = player.isMyself ? result.gradePoint : nil
        self.grade = player.isMyself ? result.grade : nil
        self.species = .INKLING
    }
}

extension Decimal {
    init?(_ value: Double?) {
        guard let value = value else {
            return nil
        }
        self.init(value)
    }
}
