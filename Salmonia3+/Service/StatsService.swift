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
    @Published var pointCard: Grizzco.PointCard = Grizzco.PointCard()
    @Published var highScore: Grizzco.HighScore = Grizzco.HighScore()
    @Published var scaleCount: Grizzco.ScaleCount = Grizzco.ScaleCount()
    @Published var weaponData: Grizzco.WeaponData = Grizzco.WeaponData()
    @Published var averageData: Grizzco.AverageData = Grizzco.AverageData()
    @Published var specialData: Grizzco.SpecialData = Grizzco.SpecialData()
    @Published var waveData: Grizzco.WaveEvent = Grizzco.WaveEvent()
    //    @Published var average: Grizzco.Chart.Average = Grizzco.Chart.Average()
//    @Published var maximum: Grizzco.Chart.Maximum = Grizzco.Chart.Maximum()
//    @Published var weapons: Grizzco.Chart.Weapons = Grizzco.Chart.Weapons()
//    @Published var special: Grizzco.Chart.SpecialWeapons = Grizzco.Chart.SpecialWeapons()
//    @Published var points: Grizzco.Chart.Card = Grizzco.Chart.Card()
//    @Published var scales: Grizzco.Chart.Scale = Grizzco.Chart.Scale()
//    @Published var values: Grizzco.Chart.Values = Grizzco.Chart.Values()
//    @Published var scatters: Grizzco.Chart.Scatters = Grizzco.Chart.Scatters()
//    @Published var waves: Grizzco.Chart.Wave = Grizzco.Chart.Wave()

    init(startTime: Date?) {
        guard let startTime = startTime,
              let schedule: RealmCoopSchedule = RealmService.shared.objects(ofType: RealmCoopSchedule.self).first(where: { $0.startTime == startTime })
        else {
            return
        }
        let players: RealmSwift.Results<RealmCoopPlayer> = RealmService.shared.objects(ofType: RealmCoopPlayer.self)
            .filter("ANY link.link.startTime=%@ AND isMyself=true", startTime)
        let waves: RealmSwift.Results<RealmCoopWave> = RealmService.shared.objects(ofType: RealmCoopWave.self)
            .filter("ANY link.link.startTime=%@", startTime)

        self.pointCard = Grizzco.PointCard(results: schedule.results, players: players)
        self.highScore = Grizzco.HighScore(results: schedule.results)
        self.scaleCount = Grizzco.ScaleCount(results: schedule.results)
        self.weaponData = Grizzco.WeaponData(schedule: schedule, players: players)
        self.averageData = Grizzco.AverageData(schedule: schedule, players: players)
        self.specialData = Grizzco.SpecialData(players: players)
        self.waveData = Grizzco.WaveEvent(waves: waves)
        //        self.average = Grizzco.Chart.Average(schedule: schedule, players: players)
//        self.maximum = Grizzco.Chart.Maximum(results: schedule.results)
//        self.weapons = Grizzco.Chart.Weapons(schedule: schedule, players: players)
//        self.points = Grizzco.Chart.Card(results: schedule.results, players: players)
//        self.scales = Grizzco.Chart.Scale(results: schedule.results)
//        self.special = Grizzco.Chart.SpecialWeapons(players: players)
//        self.values = Grizzco.Chart.Values(results: schedule.results, players: players)
//        self.scatters = Grizzco.Chart.Scatters(results: schedule.results)
//        self.waves = Grizzco.Chart.Wave(waves: waves)
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
