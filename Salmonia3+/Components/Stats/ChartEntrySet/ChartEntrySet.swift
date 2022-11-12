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
    associatedtype ChartEntryType = ChartEntry
    var id: UUID { get }
    /// ラベル
    var label: LocalizedType { get }
    /// データセット
    var data: [ChartEntryType] { get }
    
    init(label: LocalizedType, data: [ChartEntryType])
    func xAvg() -> Double
    func xMax() -> Double
    func xMin() -> Double
    func yAvg() -> Double
    func yMax() -> Double
    func yMin() -> Double
}

extension ChartEntrySet {
    public var id: UUID { UUID() }
}
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
