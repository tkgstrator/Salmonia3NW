//
//  LineChartEntry.swift
//  Salmonia3+
//
//  Created by devonly on 2022/11/12.
//

import Foundation
import SplatNet3

public class LineChartEntry: ChartEntry {
    public let x: Double
    public let y: Double
    public let isClear: Bool

    required public init<T: BinaryInteger>(x: T, y: T) {
        self.x = Double(x)
        self.y = Double(y)
        self.isClear = true
    }

    required public init<T: BinaryFloatingPoint>(x: T, y: T) {
        self.x = Double(x)
        self.y = Double(y)
        self.isClear = true
    }

    init<T: BinaryFloatingPoint, S: BinaryInteger>(x: S, y: T, isClear: Bool = true) {
        self.x = Double(x)
        self.y = Double(y)
        self.isClear = isClear
    }
}

extension Array where Element: BinaryInteger {
    func asLineChartEntry(id: LocalizedType) -> LineChartEntrySet {
        LineChartEntrySet(label: id, data: self.enumerated().map({ LineChartEntry(x: $0.offset, y: Double($0.element)) }))
    }
}

extension Array where Element: BinaryFloatingPoint {
    func asLineChartEntry(id: LocalizedType) -> LineChartEntrySet {
        LineChartEntrySet(label: id, data: self.enumerated().map({ LineChartEntry(x: $0.offset, y: $0.element) }))
    }
}