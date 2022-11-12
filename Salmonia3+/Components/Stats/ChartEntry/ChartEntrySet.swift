//
//  ChartEntrySet.swift
//  Salmonia3+
//
//  Created by devonly on 2022/11/12.
//

import Foundation
import SplatNet3

/// チャートのエントリセット
public protocol ChartEntrySet: Identifiable {
    /// ラベル
    var legend: LocalizedType { get }
    /// データセット
    var data: [any ChartEntry] { get }
    
    init(legend: LocalizedType, data: [any ChartEntry])
    func xAvg() -> Double
    func xMax() -> Double
    func xMin() -> Double
    func yAvg() -> Double
    func yMax() -> Double
    func yMin() -> Double
}

extension ChartEntrySet {
    /// xの平均値
    func xAvg() -> Double {
        self.data.compactMap({ $0.x }).reduce(0, +) / Double(data.count)
    }

    /// xの最大値
    func xMax() -> Double {
        self.data.compactMap({ $0.x }).max(by: { $0 < $1 }) ?? .zero
    }

    /// xの最小値
    func xMin() -> Double {
        self.data.compactMap({ $0.x }).min(by: { $0 < $1 }) ?? .zero
    }

    /// yの平均値
    func yAvg() -> Double {
        self.data.compactMap({ $0.y }).reduce(0, +) / Double(data.count)
    }

    /// yの最大値
    func yMax() -> Double {
        self.data.compactMap({ $0.y }).max(by: { $0 < $1 }) ?? .zero
    }

    /// yの最小値
    func yMin() -> Double {
        self.data.compactMap({ $0.y }).min(by: { $0 < $1 }) ?? .zero
    }
}

//extension Array where Element: BinaryFloatingPoint {
//    func asLineChartEntry(id: LocalizedType) -> ChartEntrySet {
//        Grizzco.ChartEntrySet(legend: id, data: self.enumerated().map({ ChartEntry(x: $0.offset, y: $0.element) }))
//    }
//}
//
//extension Array where Element: BinaryInteger {
//    func asLineChartEntry(id: LocalizedType) -> ChartEntrySet {
//        Grizzco.ChartEntrySet(legend: id, data: self.enumerated().map({ ChartEntry(x: $0.offset, y: Double($0.element)) }))
//    }
//}
//
//extension Array where Element == ChartEntrySet {
//    var xMax: Double {
//        return self.map({ $0.xMax() }).max() ?? .zero
//    }
//
//    var yMax: Double {
//        return self.map({ $0.yMax() }).max() ?? .zero
//    }
//
//    var xMin: Double {
//        return self.map({ $0.xMin() }).min() ?? .zero
//    }
//
//    var yMin: Double {
//        return self.map({ $0.yMin() }).min() ?? .zero
//    }
//}
