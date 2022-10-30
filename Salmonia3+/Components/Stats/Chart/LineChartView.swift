//
//  LineChartView.swift
//  Salmonia3+
//
//  Created by devonly on 2022/10/30.
//

import SwiftUI
import Charts
import SplatNet3

@available(iOS 16.0, *)
struct LineChartView: View {
    typealias ChartEntry = Grizzco.LineChartEntry
    @Environment(\.colorScheme) var colorScheme
    let chartData: [ChartEntry]
    let method: InterpolationMethod = .stepCenter

    init(method: InterpolationMethod = .stepCenter) {
        self.chartData = []
    }

    init(chartData: [ChartEntry]) {
        self.chartData = chartData
    }

    init(chartData: ChartEntry) {
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
    typealias ChartEntry = Grizzco.LineChartEntry

    static let chartData: [ChartEntry] = [
        ChartEntry(id: .CoopHistory_JobRatio),
        ChartEntry(id: .CoopHistory_Score),
    ]

    static var previews: some View {
        VStack(content: {
            LineChartView()
            LineChartView()
        })
        .preferredColorScheme(.dark)
    }
}
