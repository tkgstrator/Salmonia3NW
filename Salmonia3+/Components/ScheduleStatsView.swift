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
            LazyVGrid(columns: Array(repeating: .init(.flexible(maximum: 300), alignment: .top), count: 1), content: {
                GrizzcoCard(average: stats.average)
            })
            LazyVGrid(columns: Array(repeating: .init(.flexible(maximum: 197.5), alignment: .top), count: 2), content: {
                LazyVGrid(columns: [.init(.flexible())], spacing: 10, content: {
                    GrizzcoHighCard(maximum: stats.maximum)
                    GrizzcoScaleCard(scale: stats.scale)
                })
                GrizzcoPointCard(point: stats.point)
            })
        })
        .padding(.horizontal)
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
