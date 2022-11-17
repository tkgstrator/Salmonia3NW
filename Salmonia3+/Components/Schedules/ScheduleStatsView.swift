//
//  ScheduleStatsView.swift
//  Salmonia3+
//
//  Created by tkgstrator on 2022/10/09.
//

import SwiftUI
import SplatNet3
import SwiftUIX

struct ScheduleStatsView: View {
    @Environment(\.colorScheme) var colorScheme
    @ObservedObject var stats: StatsService

    init(startTime: Date) {
        self.stats = StatsService(startTime: startTime)
    }

    var body: some View {
        ScrollView(showsIndicators: false, content: {
            LazyVStack(content: {
                GrizzcoOverview(stats: stats)
                LazyVGrid(columns: Array(repeating: .init(.flexible(maximum: 197.5), alignment: .top), count: 2)) {
                    LazyVGrid(columns: [.init(.flexible())], content: {
                        GrizzcoHighScoreView(data: stats.highScore)
                        GrizzcoScaleView(data: stats.scaleCount)
                        GrizzcoWeaponView(data: stats.weaponData)
//                        GrizzcoRateView(data: stats.rateData)
                    })
                    GrizzcoCardView(data: stats.pointCard)
                    GrizzcoTeamView(data: stats.valueData)
                }
            })
        })
        .onAppear(perform: {
            stats.calculate()
        })
        .padding(.horizontal)
        .background(colorScheme == .dark ? SPColor.SplatNet3.SPBackground : Color.white)
        .navigationBarBackButtonHidden()
        .navigationBarTitleDisplayMode(.inline)
        .navigationTitle(Text(bundle: .StageSchedule_Title))
    }
}