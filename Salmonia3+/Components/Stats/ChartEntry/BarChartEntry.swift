//
//  BarChartEntry.swift
//  Salmonia3+
//
//  Created by devonly on 2022/11/13.
//

import Foundation
import SplatNet3

public class BarChartEntry: Identifiable {
    public let id: UUID = UUID()
    public let x: SakelienType
    public let y: Double
    public let isMyself: Bool

    required public init<T: BinaryFloatingPoint>(x: SakelienType, y: T, isMyself: Bool) {
        self.x = x
        self.y = Double(y)
        self.isMyself = isMyself
    }
}
