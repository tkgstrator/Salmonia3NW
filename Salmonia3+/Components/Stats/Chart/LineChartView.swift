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
    typealias ChartEntry = Grizzco.ChartEntrySet
    @Environment(\.colorScheme) var colorScheme
    let legend: LocalizedType
    let chartData: [ChartEntry]
    let method: InterpolationMethod = .stepCenter
    private var xAxis: [Double] = []
    private var yAxis: [Double] = []

    init(legend: LocalizedType = .CoopHistory_Title, chartData: [ChartEntry]) {
        self.legend = legend
        self.chartData = chartData
        if let series = chartData.first {
            self.xAxis = stride(from: 0, through: Double(series.data.count), by: Double(series.data.count) / 5).map({ $0 })
            if chartData.xMax != chartData.xMin {
                self.yAxis = stride(from: chartData.xMin, through: chartData.xMax, by: (chartData.xMax - chartData.xMin) / 5).map({ $0 })
            }
        }
    }

    init(legend: LocalizedType, chartData: ChartEntry) {
        self.init(legend: legend, chartData: [chartData])
    }

    var body: some View {
        GroupBox(label: Text(bundle: legend), content: {
            Chart(content: {
                ForEach(chartData, id: \.id) { series in
                    ForEach(series.data) { item in
                        LineMark(
                            x: .value("x", item.x),
                            y: .value("y", item.y)
                        )
                        .interpolationMethod(.stepStart)
                    }
                    .foregroundStyle(by: .value("Type", series.legend.localized))
                }
            })
            .chartYScale(domain: chartData.yMin ... chartData.yMax)
            .chartXScale(domain: 0 ... (chartData.first?.data.count ?? 0))
        })
        .padding()
        .frame(height: 300)
        .preferredColorScheme(colorScheme)
    }
}

@available(iOS 16.0, *)
struct LineChartView_Previews: PreviewProvider {
    typealias ChartEntry = Grizzco.ChartEntrySet

    static let chartData: [ChartEntry] = [
        ChartEntry(legend: .CoopHistory_JobRatio),
        ChartEntry(legend: .CoopHistory_Score),
    ]

    static var previews: some View {
        VStack(content: {
//            LineChartView()
//            LineChartView()
        })
        .preferredColorScheme(.dark)
    }
}
