//
//  GrizzcoOverview.swift
//  Salmonia3+
//
//  Created by tkgstrator on 2022/10/30.
//

import SwiftUI
import SwiftUIX

struct GrizzcoOverview: View {
    @ObservedObject var stats: StatsService
    @State private var selection: Int = 0

    var body: some View {
        TabView(selection: $selection, content: {
            if #available(iOS 16.0, *), !stats.averageData.chart.entries.isEmpty {
                ChartView(destination: {
                    PlotChartView(chart: stats.averageData.chart)
                }, content: {
                    GrizzcoAverageView(data: stats.averageData)
                })
                .tag(0)
            } else {
                GrizzcoAverageView(data: stats.averageData)
                    .tag(0)
            }
            GrizzcoSpecialView(chart: stats.specialData)
                .tag(1)
            if #available(iOS 16.0, *), !stats.averageData.chart.entries.isEmpty {
                ChartView(destination: {
                    BarChartView(chart: stats.bossData.chart)
                }, content: {
                    GrizzcoDefeatedView()
                })
                .tag(3)
            } else {
                GrizzcoDefeatedView()
                    .tag(3)
            }
            NavigationLink(destination: {
                WaveChartView(data: stats.waveData)
            }, label: {
                GrizzcoWaveView()
            })
            .tag(2)
        })
        .frame(height: 160, alignment: .bottom)
        .tabViewStyle(.page(indexDisplayMode: .never))
    }
}
