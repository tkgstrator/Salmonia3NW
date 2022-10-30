//
//  StatsService.swift
//  Salmonia3+
//
//  Created by devonly on 2022/10/08.
//

import Foundation
import RealmSwift
import SplatNet3
import SwiftUI

final class StatsService: ObservableObject {
    @Published var average: Grizzco.ChartEntry.Average = Grizzco.ChartEntry.Average()
    @Published var maximum: Grizzco.ChartEntry.Maximum = Grizzco.ChartEntry.Maximum()
    @Published var weapons: Grizzco.ChartEntry.Weapons = Grizzco.ChartEntry.Weapons()

    init(startTime: Date?) {
        guard let startTime = startTime,
              let schedule: RealmCoopSchedule = RealmService.shared.objects(ofType: RealmCoopSchedule.self).first(where: { $0.startTime == startTime })
        else {
            return
        }
        let players: RealmSwift.Results<RealmCoopPlayer> = RealmService.shared.objects(ofType: RealmCoopPlayer.self)
            .filter("ANY link.link.startTime=%@ AND isMyself=true", startTime)

        self.average = Grizzco.ChartEntry.Average(schedule: schedule, players: players)
        self.maximum = Grizzco.ChartEntry.Maximum(results: schedule.results)
    }
}

extension Array where Element: BinaryFloatingPoint {
    func asLineChartEntry(id: LocalizedType) -> LineChartEntry {
        LineChartEntry(id: id, data: self.enumerated().map({ ChartEntry(count: $0.offset, value: $0.element) }))
    }
}

extension Array where Element: BinaryInteger {
    func asLineChartEntry(id: LocalizedType) -> LineChartEntry {
        LineChartEntry(id: id, data: self.enumerated().map({ ChartEntry(count: $0.offset, value: $0.element) }))
    }
}

extension RealmCoopResult {
    var gradePointCrew: Double? {
        guard let grade = self.grade,
              let gradePoint = self.gradePoint else {
            return nil
        }
        return (self.dangerRate * 100 * 5 * 4 - Double(grade.rawValue * 100 + gradePoint)) / 3 - Double(grade.rawValue * 100)
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
