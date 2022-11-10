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
    let chartData: [ChartEntry]
    let method: InterpolationMethod = .stepCenter
    private var xAxis: [Double] = []
    private var yAxis: [Double] = []

    init(method: InterpolationMethod = .stepCenter) {
        self.chartData = []
    }

    init(chartData: [ChartEntry]) {
        self.chartData = chartData
        if let series = chartData.first {
            self.xAxis = stride(from: 0, through: Double(series.data.count), by: Double(series.data.count) / 5).map({ $0 })
            if chartData.maxValue != chartData.minValue {
                self.yAxis = stride(from: chartData.minValue, through: chartData.maxValue, by: (chartData.maxValue - chartData.minValue) / 5).map({ $0 })
            }
        }
    }

    init(chartData: ChartEntry) {
        self.chartData = [chartData]
    }

    var body: some View {
        GroupBox(label: Text(bundle: .Carousel_CoopHistory), content: {
            Chart(content: {
                ForEach(chartData, id: \.id) { series in
                    ForEach(series.data) { item in
                        LineMark(
                            x: .value("Count", item.count),
                            y: .value("Value", item.value)
                        )
                        .interpolationMethod(.stepStart)
                    }
                    .foregroundStyle(by: .value("Type", series.title.localized))
//                    RuleMark(y: .value("Average", series.average()))
//                        .foregroundStyle(.red)
                }
            })
            .chartYScale(domain: chartData.minValue ... chartData.maxValue)
            .chartXScale(domain: 0 ... (chartData.first?.data.count ?? 0))
//            .chartXAxis {
//                AxisMarks(values: xAxis)
//            }
//            .chartYAxis {
//                AxisMarks(values: yAxis)
//            }
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
        ChartEntry(title: .CoopHistory_JobRatio),
        ChartEntry(title: .CoopHistory_Score),
    ]

    static var previews: some View {
        VStack(content: {
            LineChartView()
            LineChartView()
        })
        .preferredColorScheme(.dark)
    }
}

extension Array where Element == Grizzco.ChartEntrySet {
    var maxValue: Double {
        return self.flatMap({ $0.data.map({ $0.value })}).max() ?? .zero
    }

    var minValue: Double {
        return self.flatMap({ $0.data.map({ $0.value })}).min() ?? .zero
    }
}
