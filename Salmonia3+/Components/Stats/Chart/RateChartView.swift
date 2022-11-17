//
//  RateChartView.swift
//  Salmonia3+
//
//  Created by devonly on 2022/11/15.
//

import SwiftUI
import Charts
import SplatNet3

@available(iOS 16.0, *)
struct RateChartView: View {
    @Environment(\.colorScheme) var colorScheme
    let chart: PlotChartEntryData

    init(chart: PlotChartEntryData) {
        self.chart = chart
    }

    var body: some View {
        GroupBox(label: Text(bundle: chart.legend), content: {
            Chart(content: {
                ForEach(chart.entries, id: \.id) { entry in
                    ForEach(entry.data) { item in
                        PointMark(
                            x: .value("x", item.x),
                            y: .value("y", item.y)
                        )
//                        .symbol(item.isClear ? .circle : .cross)
//                        .symbol(by: .value("Type", item.isClear ? LocalizedType.CoopHistory_Clear.localized : LocalizedType.CoopHistory_Failure.localized) )
                        .foregroundStyle(item.isClear ? .blue : .red)
                    }
                }
            })
//            .chartYAxis {
//                AxisMarks(position: .leading)
//            }
            .chartXScale(domain: chart.xMin()...chart.xMax())
//            .chartXAxisLabel(position: .bottom, alignment: .center) {
//                Text(bundle: .CoopHistory_GoldenDeliverCount) + Text(" (%)")
//            }
//            .chartYAxisLabel(position: .leading, alignment: .center) {
//                Text(bundle: .CoopHistory_DeliverCount) + Text(" (%)")
//            }
        })
        .padding()
        .frame(height: 500)
        .preferredColorScheme(colorScheme)
    }
}

//struct RateChartView_Previews: PreviewProvider {
//    static var previews: some View {
//        RateChartView()
//    }
//}
