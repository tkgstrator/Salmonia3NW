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
            if #available(iOS 16.0, *) {
                ChartView(destination: {
                    PlotChartView(chartData: stats.scatters.entries)
                }, content: {
                    GrizzcoAverageView(data: stats.average)
                })
                .tag(0)
            } else {
                GrizzcoAverageView(data: stats.average)
                    .tag(0)
            }
            GrizzcoSpecialView(data: stats.special)
                .tag(1)
            if #available(iOS 16.0, *) {
                ChartView(destination: {
                    EmptyView()
                }, content: {
                    GrizzcoWaveView(data: stats.waves)
                })
                .tag(0)
            } else {
                GrizzcoWaveView(data: stats.waves)
                    .tag(2)
            }
        })
        .frame(height: 160, alignment: .bottom)
        .tabViewStyle(.page(indexDisplayMode: .never))
    }
}

//struct GrizzcoOverview_Previews: PreviewProvider {
//    static var previews: some View {
//        GrizzcoOverview()
//    }
//}
