//
//  ScheduleStatsView.swift
//  Salmonia3+
//
//  Created by devonly on 2022/10/09.
//

import SwiftUI
import SwiftUICharts

struct ScheduleStatsView: View {
    @StateObject var stats: StatsService

    init(startTime: Date) {
        self._stats = StateObject(wrappedValue: StatsService(startTime: startTime))
    }

    var body: some View {
        ScrollView(content: {
            LazyVGrid(columns: Array(repeating: .init(.flexible()), count: 1), content: {
                WeaponChartView(data: stats.weaponCounts, weaponList: stats.weaponList, title: Text(bundle: .CoopHistory_SupplyWeapon))
                CircleChartView(data: stats.specialCounts, title: Text(bundle: .MyOutfits_Special))
            })
            LazyVGrid(columns: Array(repeating: .init(.flexible(), alignment: .top), count: 2), content: {
                SingleChartView(data: stats.teamIkuraStats, title: Text(bundle: .CoopHistory_DeliverCount))
                SingleChartView(data: stats.teamGoldenIkuraStats, title: Text(bundle: .CoopHistory_GoldenDeliverCount))
                SingleChartView(data: stats.ikuraStats, title: Text(bundle: .CoopHistory_DeliverCount))
                SingleChartView(data: stats.goldenIkuraStats, title: Text(bundle: .CoopHistory_GoldenDeliverCount))
                SingleChartView(data: stats.assistIkuraStats, title: Text(bundle: .CoopHistory_GoldenDeliverCount))
                SingleChartView(data: stats.helpStats, title: Text(bundle: .CoopHistory_RescueCount))
                SingleChartView(data: stats.deathStats, title: Text(bundle: .CoopHistory_RescuedCount))
                SingleChartView(data: stats.defeatedStats, title: Text(bundle: .CoopHistory_Enemy))
            })
        })
        .navigationTitle(Text(bundle: .StageSchedule_Title))
    }
}

struct ScheduleStatsView_Previews: PreviewProvider {
    static var previews: some View {
        ScheduleStatsView(startTime: Date(rawValue: "2022-10-01T16:00:00.000Z")!)
    }
}
