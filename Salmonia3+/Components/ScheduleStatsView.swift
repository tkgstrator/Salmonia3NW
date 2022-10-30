//
//  ScheduleStatsView.swift
//  Salmonia3+
//
//  Created by devonly on 2022/10/09.
//

import SwiftUI
import SplatNet3
import SwiftUIX

struct ScheduleStatsView: View {
    @ObservedObject var stats: StatsService

    init(startTime: Date) {
        self.stats = StatsService(startTime: startTime)
    }

    var body: some View {
        ScrollView(content: {
            GrizzcoOverview(stats: stats)
            LazyVGrid(columns: Array(repeating: .init(.flexible(maximum: 197.5), alignment: .top), count: 2)) {
                LazyVGrid(columns: [.init(.flexible())], content: {
                    GrizzcoMaximumView(data: stats.maximum)
                    GrizzcoScaleView(data: stats.scales)
                    GrizzcoWeaponView(data: stats.weapons)
                })
                GrizzcoPointView(data: stats.points)
            }
        })
        .padding(.horizontal)
        .backgroundForResult()
        .navigationBarBackButtonHidden()
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
