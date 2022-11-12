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
}

extension ChartEntry {
    public var id: UUID { UUID() }
}
