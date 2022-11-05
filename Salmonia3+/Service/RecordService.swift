//
//  RecordService.swift
//  Salmonia3+
//
//  Created by Shota Morimoto on 2022/11/05.
//  
//

import Foundation
import RealmSwift
import SplatNet3

final class RecordService: ObservableObject {
    @Published var results: [Grizzco.Record.Stage] = []
    @Published var totals: Grizzco.Record.Total
    @Published var waves: [Grizzco.Chart.Wave] = []

    init() {
        let allCases: [StageType] = [.Shakeup, .Shakespiral, .Shakedent]
        let results: RealmSwift.Results<RealmCoopResult> = RealmService.shared.objects(ofType: RealmCoopResult.self)
        let players: RealmSwift.Results<RealmCoopPlayer> = RealmService.shared.objects(ofType: RealmCoopPlayer.self)

        self.results = allCases.map({ stageId in
            let results = results.filter("ANY link.stageId=%@", stageId)
            let players = players.filter("ANY link.link.stageId=%@ AND isMyself=true", stageId)
            return Grizzco.Record.Stage(stageId: stageId, results: results, players: players)
        })
        self.totals = Grizzco.Record.Total(results: results, players: players)
//        self.waves = WaterType.allCases.map({ waterLevel in
//            EventType.allCases.map({ eventType in
//                Grizzco.Chart.Wave(
//            })
//        })
    }
}
