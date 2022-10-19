//
//  DoughnutData.swift
//  Salmonia3+
//
//  Created by devonly on 2022/10/14.
//

import Foundation
import SplatNet3
import SwiftUI

struct DoughnutData: Identifiable {
    let id: UUID = UUID()
    let color: Color
    let value: Int
    var percent: Double = 0

    init(value: Int, color: Color) {
        self.value = value
        self.color = color
    }
}

class DoughnutChartData: ObservableObject {
    @Published var values: [DoughnutData] = []

    init(values: [Int]?, colors: [Color]) {
        guard let values = values else {
            return
        }

        self.values = zip(values, colors).map({ DoughnutData(value: $0.0, color: $0.1) })
    }

    func calc() {
        let total: Double = Double(values.map({ $0.value }).reduce(0, +))
        var sum: Double = .zero

        for (index, value) in values.enumerated() {
            sum += Double(value.value) / total
            values[index].percent = sum
        }
    }
}
