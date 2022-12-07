//
//  RealmCoopSchedule+Previews.swift
//  Salmonia3+
//  
//  Created by devonly on 2022/12/08
//  Copyright © 2022 Magi Corporation. All rights reserved.
//

import Foundation
import RealmSwift
import SplatNet3

extension RealmCoopSchedule {
    static let preview: RealmCoopSchedule = {
        let schedule = RealmCoopSchedule()
        let startTime: Date = Date(timeIntervalSince1970: 1667228400)
        let endTime: Date = Date(timeIntervalSince1970: 1669820400)
        schedule.id = startTime.hash
        schedule.stageId = .Shakedent
        schedule.startTime = startTime
        schedule.endTime = endTime
        schedule.rule = .REGULAR
        schedule.mode = .REGULAR
        schedule.weaponList.append(objectsIn: WeaponId.allCases.suffix(4))
        return schedule
    }()
}

extension RealmCoopResult {
    static let preview: RealmCoopResult = {
        let result = RealmCoopResult()
        result.id = UUID().uuidString
        result.gradePoint = 999
        result.grade = .Eggsecutive_VP
        result.isClear = true
        result.failureWave = nil
        result.bossId = .SakelienGiant
        result.ikuraNum = 9999
        result.goldenIkuraNum = 999
        result.goldenIkuraAssistNum = 999
        result.bossCounts.append(objectsIn: Array(repeating: 99, count: 15))
        result.bossKillCounts.append(objectsIn: Array(repeating: 99, count: 15))
        result.dangerRate = 3.333
        result.jobRate = 9.99
        result.jobScore = 100
        result.kumaPoint = 999
        result.jobBonus = 999
        result.smellMeter = 5
        result.waves.append(RealmCoopWave.preview)
        result.players.append(RealmCoopPlayer.preview)
        result.scale.append(objectsIn: Array(repeating: 99, count: 3))
        result.playTime = Date(timeIntervalSince1970: 1667228400)
        result.scenarioCode = nil
        return result
    }()
}

extension RealmCoopWave {
    static let preview: RealmCoopWave = {
        let wave = RealmCoopWave()
        wave.id = 0
        wave.waterLevel = .NORMAL_TIDE
        wave.eventType = .Water_Levels
        wave.isClear = true
        wave.goldenIkuraNum = 99
        wave.goldenIkuraPopNum = 99
        wave.quotaNum = 35
        return wave
    }()
}

extension RealmCoopPlayer {
    static let preview: RealmCoopPlayer = {
        let player = RealmCoopPlayer()
        player.goldenIkuraNum = 99
        player.ikuraNum = 9999
        player.goldenIkuraAssistNum = 999
        player.bossKillCounts.append(objectsIn: Array(repeating: 99, count: 15))
        player.isMyself = true
        player.specialId = .SpJetpack
        player.id = UUID().uuidString
        return player
    }()
}
