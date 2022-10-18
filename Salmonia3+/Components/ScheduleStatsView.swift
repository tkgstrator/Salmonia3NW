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
        ScrollView(.vertical, showsIndicators: true, content: {
            GrizzcoPointCardView(data: stats.grizzcoPointData)
                .padding(.horizontal, 10)
        })
        .backgroundForResult()
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
