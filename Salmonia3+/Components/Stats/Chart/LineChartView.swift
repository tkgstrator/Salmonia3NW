//
//  LineChartView.swift
//  Salmonia3+
//
//  Created by devonly on 2022/10/30.
//

import SwiftUI
import Charts
import SplatNet3

struct LineChartEntry: Identifiable {
    let id: LocalizedType
    let data: [ChartEntry]

    init(id: LocalizedType) {
        self.id = id
        self.data = (0...20).map({ ChartEntry(count: $0, value: Double.random(in: 0...15))})
    }

    init(id: LocalizedType, data: [ChartEntry]) {
        self.id = id
        self.data = data
    }
}

struct ChartEntry: Identifiable {
    let id: UUID = UUID()
    let count: Int
    let value: Double

    init<T: BinaryInteger>(count: Int, value: T) {
        self.count = count
        self.value = Double(value)
    }

    init<T: BinaryFloatingPoint>(count: Int, value: T) {
        self.count = count
        self.value = Double(value)
    }
}

@available(iOS 16.0, *)
struct LineChartView: View {
    @Environment(\.colorScheme) var colorScheme
    let chartData: [LineChartEntry]
    let method: InterpolationMethod = .stepCenter

    init(method: InterpolationMethod = .stepCenter) {
        self.chartData = []
    }

    init(chartData: [LineChartEntry]) {
        self.chartData = chartData
    }

    init(chartData: LineChartEntry) {
        self.chartData = []
    }

    var body: some View {
        GroupBox(label: Text(bundle: .CoopHistory_JobRatio), content: {
            Chart(content: {
                ForEach(chartData, id: \.id) { series in
                    ForEach(series.data) { item in
                        LineMark(
                            x: .value("Count", item.count),
                            y: .value("Value", item.value)
                        )
                        .interpolationMethod(.stepStart)
                    }
                    .foregroundStyle(by: .value("Type", series.id.localized))
                }
            })
        })
        .padding()
        .frame(height: 300)
        .preferredColorScheme(colorScheme)
    }
}

@available(iOS 16.0, *)
struct LineChartView_Previews: PreviewProvider {
    static let chartData: [LineChartEntry] = [
        LineChartEntry(id: .CoopHistory_JobRatio),
        LineChartEntry(id: .CoopHistory_Score),
    ]

    static var previews: some View {
        VStack(content: {
            LineChartView()
            LineChartView()
        })
        .preferredColorScheme(.dark)
    }
}
