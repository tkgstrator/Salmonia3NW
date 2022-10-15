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
        GeometryReader(content: { geometry in
            let columnsCount: Int = geometry.width >= 600 ? 2 : 1
            ScrollView(content: {
                LazyVGrid(columns: Array(repeating: .init(.flexible(maximum: 200), alignment: .top), count: 2), content: {
                    LazyVStack(alignment: .center, spacing: nil, content: {
                        AbstructView(data: stats.abstructData)
                        Spacer()
                        ScaleChartView(data: stats.scaleData)
                    })
                    GrizzcoPointCard(data: stats.grizzcoPointData)
                })
                .padding([.horizontal])
                /// 描画が乱れるので分岐する
                switch columnsCount == 1 {
                case true:
                    VStack(alignment: .center, spacing: nil, content: {
                        WeaponChartView(data: stats.weaponCounts, weaponList: stats.weaponList, title: Text(bundle: .CoopHistory_SupplyWeapon))
                        SpecialChartView(data: stats.specialCounts, title: Text(bundle: .MyOutfits_Special))
                    })
                    .frame(maxWidth: 400)
                    .padding([.horizontal])
                case false:
                    LazyVGrid(columns: Array(repeating: .init(.flexible(maximum: 400)), count: columnsCount), content: {
                        WeaponChartView(data: stats.weaponCounts, weaponList: stats.weaponList, title: Text(bundle: .CoopHistory_SupplyWeapon))
                        SpecialChartView(data: stats.specialCounts, title: Text(bundle: .MyOutfits_Special))
                    })
                    .padding([.horizontal])
                }
                LazyVGrid(columns: Array(repeating: .init(.flexible(maximum: 400)), count: columnsCount), content: {
                    Group(content: {
                        ColumnChartView(solo: stats.ikuraStats, team: stats.teamIkuraStats, title: Text(bundle: .CoopHistory_DeliverCount))
                        ColumnChartView(solo: stats.goldenIkuraStats, team: stats.teamGoldenIkuraStats, title: Text(bundle: .CoopHistory_GoldenDeliverCount))
                        ColumnChartView(solo: stats.helpStats, team: nil, title: Text(bundle: .CoopHistory_RescueCount))
                        ColumnChartView(solo: stats.deathStats, team: nil, title: Text(bundle: .CoopHistory_RescuedCount))
                        ColumnChartView(solo: stats.defeatedStats, team: nil, title: Text(bundle: .CoopHistory_Enemy))
                    })
                })
                .padding([.horizontal])
            })
        })
        .navigationBarTitleDisplayMode(.inline)
        .navigationTitle(Text(bundle: .StageSchedule_Title))
    }
}

//struct ScheduleStatsView_Previews: PreviewProvider {
//    enum XcodePreviewDevice: String, CaseIterable {
//        case iPhoneSE = "iPhone SE"
//        case iPhone13Pro = "iPhone 13 Pro"
//        case iPadPro = "iPad Pro"
//        case iPad = "iPad (9th generation)"
//    }
//
//    static var previews: some View {
//        ForEach(XcodePreviewDevice.allCases, id:\.rawValue) { device in
//            NavigationView(content: {
//                ScheduleStatsView(startTime: Date(rawValue: "2022-10-01T16:00:00.000Z")!)
//                ScheduleStatsView(startTime: Date(rawValue: "2022-10-01T16:00:00.000Z")!)
//            })
//            .navigationViewStyle(.split)
//            .previewDevice(PreviewDevice.init(rawValue: device.rawValue))
//            .preferredColorScheme(.dark)
//        }
//        .previewInterfaceOrientation(.portraitUpsideDown)
//    }
//}
