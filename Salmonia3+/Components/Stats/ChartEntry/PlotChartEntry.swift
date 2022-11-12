//
//  PlotChartEntry.swift
//  Salmonia3+
//
//  Created by devonly on 2022/11/12.
//

import Foundation
import RealmSwift
import SplatNet3

public class PlotChartEntry: ChartEntry {
    public let x: Double
    public let y: Double
    public let isClear: Bool

    required public init<T: BinaryInteger>(x: T, y: T, isClear: Bool) {
        self.x = Double(x)
        self.y = Double(y)
        self.isClear = isClear
    }

    public init(x: Double, y: Double, isClear: Bool) {
        self.x = x
        self.y = y
        self.isClear = isClear
    }

    required public init<T: BinaryFloatingPoint>(x: T, y: T, isClear: Bool) {
        self.x = Double(x)
        self.y = Double(y)
        self.isClear = isClear
    }

    init<T: BinaryFloatingPoint, S: BinaryInteger>(x: S, y: T, isClear: Bool) {
        self.x = Double(x)
        self.y = Double(y)
        self.isClear = isClear
    }
}

extension RealmSwift.Results where Element == RealmCoopPlayer {
    func asPlotChartEntry(id: LocalizedType) -> PlotChartEntrySet {
        PlotChartEntrySet(
            label: id,
            data: self.compactMap({
                guard let result: RealmCoopResult = $0.result else {
                    return nil
                }
                return PlotChartEntry(
                    x: Double($0.goldenIkuraNum) / Double(result.goldenIkuraNum),
                    y: Double($0.ikuraNum) / Double(result.ikuraNum),
                    isClear: $0.isClear
                )
            }))
    }

}

extension RealmSwift.List where Element == RealmCoopResult {
    func asPlotChartEntry(id: LocalizedType) -> PlotChartEntrySet {
        let data: [PlotChartEntry] = self.flatMap({ result -> [PlotChartEntry] in
            result.players.map({ player -> PlotChartEntry in
                PlotChartEntry(
                    x: Double(player.goldenIkuraNum) / Double(result.goldenIkuraNum),
                    y: Double(player.ikuraNum) / Double(result.ikuraNum),
                    isClear: player.isClear
                )
            })
        })
        return PlotChartEntrySet(label: id, data: data)
    }
}

extension RealmCoopPlayer {
    var isClear: Bool {
        self.result?.isClear ?? false
    }
}
