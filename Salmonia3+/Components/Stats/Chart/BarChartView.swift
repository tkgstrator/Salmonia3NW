//
//  BarChartView.swift
//  Salmonia3+
//
//  Created by Shota Morimoto on 2022/11/05.
//  
//

import SwiftUI
import Charts
import SplatNet3

@available(iOS 16.0, *)
struct BarChartView: View {
    @Environment(\.colorScheme) var colorScheme
    let chart: BarChartEntryData

    var body: some View {
        GroupBox(label: Text(bundle: chart.legend), content: {
            Chart(content: {
                ForEach(chart.entries, content: { entry in
                    BarMark(
                        xStart: .value("Percentage", 0),
                        xEnd: .value("Percentage", !entry.isMyself ? entry.y : entry.y * -1 ),
                        y: .value("SakelienType", entry.x.localizedText),
                        height: .fixed(10)
                    )
                    .annotation(position: !entry.isMyself ? .trailing : .leading, alignment: .center, spacing: nil, content: {
                        Text(String(format: "%.1f%%", entry.y * 100))
                            .font(systemName: .Splatfont2, size: 11)
                    })
                    .foregroundStyle(by: .value("Player", entry.isMyself ? LocalizedType.Common_Player_You.localized : LocalizedType.Common_Player_Crew.localized))
                    .interpolationMethod(.catmullRom)
                })
            })
            .chartYAxis {
                AxisMarks(preset: .aligned, position: .automatic) { _ in
                    AxisValueLabel(centered: true)
                }
            }
            .chartXAxis {
                AxisMarks(preset: .aligned, position: .automatic) { value in
                    let rawValue = value.as(Double.self)!
                    let percentage = abs(rawValue)

                    AxisGridLine()
                    AxisValueLabel(percentage.formatted(.percent))
                }
            }
            .chartLegend(position: .top, alignment: .center)
        })
        .frame(height: 400)
        .padding(.horizontal)
        .preferredColorScheme(colorScheme)
    }
}

//@available(iOS 16.0, *)
//struct BarChartView_Previews: PreviewProvider {
//    typealias RecordEntry = Grizzco.Record.Total.BossCount
//    @Environment(\.colorScheme) var colorScheme
//    static let chartData: [RecordEntry] = SakelienType.allCases.map({ bossId in
//        RecordEntry(
//            bossId: bossId,
//            count: Int.random(in: 0...20))
//    })
//
//    static var previews: some View {
//        XBarChartView(title: .CoopHistory_Available, chartData: chartData)
//    }
//}
