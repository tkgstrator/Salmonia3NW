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
    @State private var tabCounts: Int = 4
    @State private var selection: Int = 0

    func SlideArrow(selection: Binding<Int>) -> some View {
        HStack(content: {
            Button(action: {
                withAnimation(.default) {
                    selection.wrappedValue = selection.wrappedValue  == .zero ? tabCounts - 1 : (selection.wrappedValue - 1)
                }
            }, label: {
                Text("←")
            })
            Spacer()
            Button(action: {
                withAnimation(.default) {
                    selection.wrappedValue = (selection.wrappedValue + 1) % tabCounts
                }
            }, label: {
                Text("→")
            })
        })
        .font(systemName: .Splatfont, size: 24)
        .frame(width: 340, height: nil)
    }

    var body: some View {
        TabView(selection: $selection, content: {
            if #available(iOS 16.0, *), !stats.averageData.isEmpty {
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
            if #available(iOS 16.0, *), !stats.bossData.isEmpty {
                ChartView(destination: {
                    BarChartView(chart: stats.bossData.chart)
                }, content: {
                    GrizzcoDefeatedView()
                })
                .tag(2)
            } else {
                GrizzcoDefeatedView()
                    .tag(2)
            }
            NavigationLink(destination: {
                WaveChartView(data: stats.waveData)
            }, label: {
                GrizzcoWaveView()
            })
            .tag(3)
        })
        .frame(height: 160, alignment: .bottom)
        .tabViewStyle(.page(indexDisplayMode: .never))
        .overlay(SlideArrow(selection: $selection))
    }
}
