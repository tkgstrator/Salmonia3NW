//
//  ChartEntry.swift
//  Salmonia3+
//
//  Created by devonly on 2022/11/12.
//

import Foundation

/// チャートのプロトコル
public protocol ChartEntry: Identifiable {
    /// Identifiable
    var id: UUID { get }
    /// xの値
    var x: Double { get }
    /// yの値
    var y: Double { get }

    init<T: BinaryInteger>(x: T, y: T)
    init<T: BinaryFloatingPoint>(x: T, y: T)
}

extension ChartEntry {
    var id: UUID { UUID() }
}

struct LineChartEntry: ChartEntry {
    let x: Double
    let y: Double

    init<T: BinaryInteger>(x: T, y: T) {
        self.x = Double(x)
        self.y = Double(y)
    }

    init<T: BinaryFloatingPoint>(x: T, y: T) {
        self.x = Double(x)
        self.y = Double(y)
    }
}
