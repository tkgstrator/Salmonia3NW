//
//  CoopResult.swift
//  Salmonia3+
//  
//  Created by devonly on 2022/12/31
//  Copyright © 2022 Magi Corporation. All rights reserved.
//

import Foundation
import SplatNet3

extension CoopResult {
    init(result: RealmCoopResult) throws {
        let myResult: RealmCoopPlayer = result.players.first ?? RealmCoopPlayer.preview
        let otherResults: [RealmCoopPlayer] = Array(result.players.dropFirst())
        self.init(
            id: result.id,
            uuid: result.uuid,
            scale: Array(result.scale),
            jobScore: result.jobScore,
            gradeId: result.gradeId,
            kumaPoint: result.kumaPoint,
            waveDetails: result.waves.map({ CoopResult.WaveResult(result: $0) }),
            jobResult: CoopResult.JobResult(result: result),
            myResult: CoopResult.PlayerResult(result: myResult),
            otherResults: otherResults.map({ CoopResult.PlayerResult(result: $0) }),
            gradePoint: result.gradePoint,
            jobRate: result.jobRate?.decimalValue,
            playTime: result.playTime,
            bossCounts: Array(result.bossCounts),
            bossKillCounts: Array(result.bossKillCounts),
            dangerRate: result.dangerRate.decimalValue,
            jobBonus: result.jobBonus,
            schedule: CoopResult.Schedule(result: result.schedule),
            goldenIkuraNum: result.goldenIkuraNum,
            goldenIkuraAssistNum: result.goldenIkuraAssistNum,
            ikuraNum: result.ikuraNum,
            smellMeter: result.smellMeter,
            scenarioCode: result.scenarioCode
        )
    }
}

extension CoopResult.WaveResult {
    init(result: RealmCoopWave) {
        self.init(
            id: result.id,
            isClear: result.isClear,
            waterLevel: result.waterLevel,
            eventType: result.eventType,
            goldenIkuraNum: result.goldenIkuraNum,
            quotaNum: result.quotaNum,
            goldenIkuraPopNum: result.goldenIkuraPopNum
        )
    }
}

extension CoopResult.PlayerResult {
    init(result: RealmCoopPlayer) {
        self.init(
            id: result.id,
            pid: result.uid,
            isMyself: result.isMyself,
            byname: result.byname,
            name: result.name,
            nameId: result.nameId,
            nameplate: CoopResult.Nameplate(result: result),
            goldenIkuraAssistNum: result.goldenIkuraAssistNum,
            goldenIkuraNum: result.goldenIkuraNum,
            ikuraNum: result.ikuraNum,
            deadCount: result.deadCount,
            helpCount: result.helpCount,
            weaponList: Array(result.weaponList),
            specialCounts: Array(result.specialCounts),
            bossKillCounts: Array(result.bossKillCounts),
            bossKillCountsTotal: result.bossKillCountsTotal,
            uniform: result.uniform,
            species: result.species
        )
    }
}

extension CoopResult.Schedule {
    init(result: RealmCoopSchedule) {
        self.init(
            startTime: result.startTime,
            endTime: result.endTime,
            mode: result.mode,
            rule: result.rule,
            weaponList: Array(result.weaponList),
            stageId: result.stageId
        )
    }
}

extension CoopResult.JobResult {
    init(result: RealmCoopResult) {
        self.init(
            isClear: result.isClear,
            failureWave: result.failureWave,
            isBossDefeated: result.isBossDefeated,
            bossId: result.bossId
        )
    }
}

extension CoopResult.Nameplate {
    init(result: RealmCoopPlayer) {
        self.init(
            badges: Array(result.badges),
            background: CoopResult.Background(result: result)
        )
    }
}

extension CoopResult.Background {
    init(result: RealmCoopPlayer) {
        let textColor: Common.TextColor = Common.TextColor(
            r: result.textColor[0].decimalValue,
            g: result.textColor[1].decimalValue,
            b: result.textColor[2].decimalValue,
            a: result.textColor[3].decimalValue
        )
        self.init(textColor: textColor, id: result.background)
    }
}

