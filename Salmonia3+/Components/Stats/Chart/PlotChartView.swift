//
//  PlotChartView.swift
//  Salmonia3+
//
//  Created by Shota Morimoto on 2022/11/06.
//  
//

import SwiftUI
import Charts
import SplatNet3

@available(iOS 16.0, *)
struct PlotChartView: View {
    typealias ChartEntry = Grizzco.PointEntry
    @Environment(\.colorScheme) var colorScheme
    let chartData: [ChartEntry]
//    let method: InterpolationMethod = .stepCenter
//    private var xAxis: [Double] = []
//    private var yAxis: [Double] = []

//    init(method: InterpolationMethod = .stepCenter) {
//        self.chartData = []
//    }

    init(chartData: [ChartEntry]) {
        self.chartData = chartData
//        if let series = chartData.first {
//            self.xAxis = stride(from: 0, through: Double(series.data.count), by: Double(series.data.count) / 5).map({ $0 })
//            self.yAxis = stride(from: chartData.minValue, through: chartData.maxValue, by: (chartData.maxValue - chartData.minValue) / 5).map({ $0 })
//        }
    }

    var body: some View {
        GroupBox(label: Text(bundle: .Carousel_CoopHistory), content: {
            Chart(content: {
                ForEach(chartData, id: \.id) { item in
                     PointMark(
                        x: .value("XValue", item.xValue),
                        y: .value("YValue", item.yValue)
                    )
                     .symbol(by: .value("IsClear",
                                        item.isClear
                                        ? LocalizedType.CoopHistory_Clear.localized
                                        : LocalizedType.CoopHistory_Failure.localized
                                       ))
                     .foregroundStyle(by: .value("IsClear",
                                                 item.isClear
                                                 ? LocalizedType.CoopHistory_Clear.localized
                                                 : LocalizedType.CoopHistory_Failure.localized
                                                ))
                }
                RuleMark(x: .value("Avg", 25))
                RuleMark(y: .value("Avg", 25))
            })
            .chartYAxis {
                AxisMarks(position: .leading)
            }
            .chartXAxisLabel(position: .bottom, alignment: .center) {
                Text(bundle: .CoopHistory_GoldenDeliverCount) + Text(" (%)")
            }
            .chartYAxisLabel(position: .leading, alignment: .center) {
                Text(bundle: .CoopHistory_DeliverCount) + Text(" (%)")
            }
//            .chartYScale(domain: chartData.minValue ... chartData.maxValue)
//            .chartXScale(domain: 0 ... (chartData.first?.data.count ?? 0))
        })
        .padding()
        .frame(height: 500)
        .preferredColorScheme(colorScheme)
    }
}

@available(iOS 16.0, *)
struct PlotChartView_Previews: PreviewProvider {
    static var previews: some View {
        PlotChartView(chartData: [])
    }
}
