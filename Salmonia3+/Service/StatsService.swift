//
//  StatsService.swift
//  Salmonia3+
//
//  Created by tkgstrator on 2022/10/08.
//

import Foundation
import RealmSwift
import SplatNet3
import SwiftUI

final class StatsService: ObservableObject {
    @Published var average: Grizzco.Chart.Average = Grizzco.Chart.Average()
    @Published var maximum: Grizzco.Chart.Maximum = Grizzco.Chart.Maximum()
    @Published var weapons: Grizzco.Chart.Weapons = Grizzco.Chart.Weapons()
    @Published var special: Grizzco.Chart.SpecialWeapons = Grizzco.Chart.SpecialWeapons()
    @Published var points: Grizzco.Chart.Point = Grizzco.Chart.Point()
    @Published var scales: Grizzco.Chart.Scale = Grizzco.Chart.Scale()
    @Published var values: Grizzco.Chart.Values = Grizzco.Chart.Values()

    init(startTime: Date?) {
        guard let startTime = startTime,
              let schedule: RealmCoopSchedule = RealmService.shared.objects(ofType: RealmCoopSchedule.self).first(where: { $0.startTime == startTime })
        else {
            return
        }
        let players: RealmSwift.Results<RealmCoopPlayer> = RealmService.shared.objects(ofType: RealmCoopPlayer.self)
            .filter("ANY link.link.startTime=%@ AND isMyself=true", startTime)

        self.average = Grizzco.Chart.Average(schedule: schedule, players: players)
        self.maximum = Grizzco.Chart.Maximum(results: schedule.results)
        self.weapons = Grizzco.Chart.Weapons(schedule: schedule, players: players)
        self.points = Grizzco.Chart.Point(results: schedule.results, players: players)
        self.scales = Grizzco.Chart.Scale(results: schedule.results)
        self.special = Grizzco.Chart.SpecialWeapons(players: players)
        self.values = Grizzco.Chart.Values(results: schedule.results, players: players)
    }
}

extension Collection where Self.Iterator.Element: RandomAccessCollection {
    // PRECONDITION: `self` must be rectangular, i.e. every row has equal size.
    func transposed() -> [[Self.Iterator.Element.Iterator.Element]] {
        guard let firstRow = self.first else { return [] }
        return firstRow.indices.map { index in
            self.map{ $0[index] }
        }
    }
}
