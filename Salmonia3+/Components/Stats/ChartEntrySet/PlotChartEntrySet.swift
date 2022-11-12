//
//  PlotChartEntrySet.swift
//  Salmonia3+
//
//  Created by devonly on 2022/11/12.
//

import Foundation
import SplatNet3

public class PlotChartEntryData: ObservableObject {
    /// タイトル
    @Published var legend: LocalizedType = .CoopHistory_Title
    /// エントリー
    @Published var entries: [PlotChartEntrySet] = []

    init() {}

    init(legend: LocalizedType, entries: [PlotChartEntrySet]) {
        self.legend = legend
        self.entries = entries
    }

    convenience init(legend: LocalizedType, entries: PlotChartEntrySet) {
        self.init(legend: legend, entries: [entries])
    }
}

/// チャートのエントリセット
public struct PlotChartEntrySet: ChartEntrySet {
    public typealias ChartEntryType = PlotChartEntry

    /// ラベル
    public var label: LocalizedType
    /// データセット
    public var data: [PlotChartEntry]

    public init(label: LocalizedType, data: [PlotChartEntry]) {
        self.label = label
        self.data = data
    }

    /// xの平均値
    public func xAvg() -> Double {
        self.data.compactMap({ $0.x }).reduce(0, +) / Double(data.count)
    }

    /// xの最大値
    public func xMax() -> Double {
        self.data.compactMap({ $0.x }).max(by: { $0 < $1 }) ?? .zero
    }

    /// xの最小値
    public func xMin() -> Double {
        self.data.compactMap({ $0.x }).min(by: { $0 < $1 }) ?? .zero
    }

    /// yの平均値
    public func yAvg() -> Double {
        self.data.compactMap({ $0.y }).reduce(0, +) / Double(data.count)
    }

    /// yの最大値
    public func yMax() -> Double {
        self.data.compactMap({ $0.y }).max(by: { $0 < $1 }) ?? .zero
    }

    /// yの最小値
    public func yMin() -> Double {
        self.data.compactMap({ $0.y }).min(by: { $0 < $1 }) ?? .zero
    }
}

public extension PlotChartEntryData {
    /// xの最大値
    func xMax() -> Double {
        self.entries.compactMap({ $0.xMax() }).max(by: { $0 < $1 }) ?? .zero
    }

    /// xの最小値
    func xMin() -> Double {
        self.entries.compactMap({ $0.xMin() }).min(by: { $0 < $1 }) ?? .zero
    }

    /// yの最大値
    func yMax() -> Double {
        self.entries.compactMap({ $0.yMax() }).max(by: { $0 < $1 }) ?? .zero
    }

    /// yの最小値
    func yMin() -> Double {
        self.entries.compactMap({ $0.yMin() }).min(by: { $0 < $1 }) ?? .zero
    }
}
