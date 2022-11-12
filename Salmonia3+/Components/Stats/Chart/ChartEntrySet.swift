//
//  ChartEntrySet.swift
//  Salmonia3+
//
//  Created by devonly on 2022/11/12.
//

import Foundation
import SplatNet3

extension Array where Element: BinaryFloatingPoint {
    func asLineChartEntry(id: LocalizedType) -> Grizzco.ChartEntrySet {
        Grizzco.ChartEntrySet(legend: id, data: self.enumerated().map({ Grizzco.ChartEntry(x: $0.offset, y: $0.element) }))
    }
}

extension Array where Element: BinaryInteger {
    func asLineChartEntry(id: LocalizedType) -> Grizzco.ChartEntrySet {
        Grizzco.ChartEntrySet(legend: id, data: self.enumerated().map({ Grizzco.ChartEntry(x: $0.offset, y: Double($0.element)) }))
    }
}

extension Array where Element == Grizzco.ChartEntrySet {
    var xMax: Double {
        return self.map({ $0.xMax() }).max() ?? .zero
    }

    var yMax: Double {
        return self.map({ $0.yMax() }).max() ?? .zero
    }

    var xMin: Double {
        return self.map({ $0.xMin() }).min() ?? .zero
    }

    var yMin: Double {
        return self.map({ $0.yMin() }).min() ?? .zero
    }
}
