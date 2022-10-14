//
//  SingleChartData.swift
//  Salmonia3+
//
//  Created by devonly on 2022/10/14.
//

import Foundation
import SwiftUI

public class SingleData: ObservableObject, Identifiable {
    @Published var maxValue: Int?
    @Published var minValue: Int?
    @Published var avgValue: Double?

    var valuesGiven: Bool = false
    var ID = UUID()

    public init(max: Int?, min: Int?, avg: Double?) {
        self.maxValue = {
            if let max = max {
                return max
            }
            return nil
        }()
        self.minValue = {
            if let min = min {
                return min
            }
            return nil
        }()
        self.avgValue = {
            if let avg = avg {
                return Double(avg)
            }
            return nil
        }()
    }
}
