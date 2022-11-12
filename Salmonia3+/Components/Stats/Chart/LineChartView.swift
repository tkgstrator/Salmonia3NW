//
//  LineChartView.swift
//  Salmonia3+
//
//  Created by tkgstrator on 2022/10/30.
//

import SwiftUI
import SplatNet3
import Charts

@available(iOS 16.0, *)
struct LineChartView: View {
    @Environment(\.colorScheme) var colorScheme
    let chart: LineChartEntryData
    let method: InterpolationMethod = .stepCenter

    init(chart: LineChartEntryData) {
        self.chart = chart
    }

    var body: some View {
        GroupBox(label: Text(bundle: chart.legend), content: {
            Chart(content: {
                ForEach(chart.entries, id: \.id) { entry in
                    ForEach(entry.data) { item in
                        LineMark(
                            x: .value("x", item.x),
                            y: .value("y", item.y)
                        )
                        .interpolationMethod(.stepStart)
                    }
                    .foregroundStyle(by: .value("Type", entry.label.localized))
                }
            })
            .chartYScale(domain: chart.yMin() ... chart.yMax())
            .chartXScale(domain: chart.xMin() ... chart.xMax())
        })
        .padding()
        .frame(height: 300)
        .preferredColorScheme(colorScheme)
    }
}
//
//@available(iOS 16.0, *)
//struct LineChartView_Previews: PreviewProvider {
//    typealias ChartEntry = Grizzco.ChartEntrySet
//
//    static let chartData: [ChartEntry] = [
//        ChartEntry(legend: .CoopHistory_JobRatio),
//        ChartEntry(legend: .CoopHistory_Score),
//    ]
//
//    static var previews: some View {
//        VStack(content: {
////            LineChartView()
////            LineChartView()
//        })
//        .preferredColorScheme(.dark)
//    }
//}
