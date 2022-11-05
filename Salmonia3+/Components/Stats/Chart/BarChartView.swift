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
    typealias ChartEntry = Grizzco.ChartEntrySet
    @Environment(\.colorScheme) var colorScheme

    var body: some View {
        Chart(content: {


        })
    }
}

@available(iOS 16.0, *)
struct BossKillChartTab: View {
    @ObservedObject var data: Grizzco.Record.Total

    var body: some View {
        TabView(content: {
            XBarChartView(title: .CoopHistory_Available ,chartData: data.bossCounts)
            XBarChartView(title: .CoopHistory_DefeatedEnemies ,chartData: data.bossKillCounts)
        })
        .frame(height: 600)
        .tabViewStyle(.page(indexDisplayMode: .always))
    }
}

@available(iOS 16.0, *)
struct XBarChartView: View {
    typealias RecordEntry = Grizzco.Record.Total.BossCount
    @Environment(\.colorScheme) var colorScheme
    let title: LocalizedType
    let chartData: [RecordEntry]

    var body: some View {
        GroupBox(label: Text(bundle: title), content: {
            Chart(content: {
                ForEach(chartData, id: \.id, content: { series in
                    BarMark(
                        x: .value("Value", series.count),
                        y: .value("Category", series.bossId.localizedText))
                    .annotation(position: .overlay, alignment: .center,  content: {
                        Text(String(format: "%d", series.count))
                            .bold()
                            .foregroundColor(.white)
                    })
                })
            })
        })
        .padding()
        .frame(height: 600)
        .preferredColorScheme(colorScheme)
    }
}

@available(iOS 16.0, *)
struct BarChartView_Previews: PreviewProvider {
    typealias RecordEntry = Grizzco.Record.Total.BossCount
    @Environment(\.colorScheme) var colorScheme
    static let chartData: [RecordEntry] = SakelienType.allCases.map({ bossId in
        RecordEntry(
            bossId: bossId,
            count: Int.random(in: 0...20))
    })

    static var previews: some View {
        XBarChartView(title: .CoopHistory_Available, chartData: chartData)
    }
}
