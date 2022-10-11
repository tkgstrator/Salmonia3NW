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
            VStack(content: {
                Group(content: {
                    GradePointChartView(data: stats.gradePointHistory, title: Text(bundle: .CoopHistory_JobRatio))
                    WeaponChartView(data: stats.weaponCounts, weaponList: stats.weaponList, title: Text(bundle: .CoopHistory_SupplyWeapon))
                    SpecialChartView(data: stats.specialCounts, title: Text(bundle: .MyOutfits_Special))
                    ColumnChartView(solo: stats.ikuraStats, team: stats.teamIkuraStats, title: Text(bundle: .CoopHistory_DeliverCount))
                    ColumnChartView(solo: stats.goldenIkuraStats, team: stats.teamGoldenIkuraStats, title: Text(bundle: .CoopHistory_GoldenDeliverCount))
                    ColumnChartView(solo: stats.helpStats, team: nil, title: Text(bundle: .CoopHistory_RescueCount))
                    ColumnChartView(solo: stats.deathStats, team: nil, title: Text(bundle: .CoopHistory_RescuedCount))
                    ColumnChartView(solo: stats.defeatedStats, team: nil, title: Text(bundle: .CoopHistory_Enemy))
                })
                Group(content: {
                    ColumnChartView(solo: stats.defeatedStats, team: nil, title: Text(bundle: .CoopHistory_Scale))
                    ColumnChartView(solo: stats.defeatedStats, team: nil, title: Text(bundle: .CoopHistory_DefeatBoss))
                    ColumnChartView(solo: stats.defeatedStats, team: nil, title: Text(bundle: .CoopHistory_DefeatedEnemies))
                    ColumnChartView(solo: stats.defeatedStats, team: nil, title: Text(bundle: .CoopHistory_PlayCount))
                    ColumnChartView(solo: stats.defeatedStats, team: nil, title: Text(bundle: .CoopHistory_AverageClearWaves))
                })
            })
        })
        .transition(.identity)
        .navigationTitle(Text(bundle: .StageSchedule_Title))
    }
}

struct ScheduleStatsView_Previews: PreviewProvider {
    static var previews: some View {
        ScheduleStatsView(startTime: Date(rawValue: "2022-10-01T16:00:00.000Z")!)
            .preferredColorScheme(.dark)
    }
}
