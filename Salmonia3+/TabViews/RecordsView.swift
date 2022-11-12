//
//  RecordsView.swift
//  Salmonia3+
//
//  Created by Shota Morimoto on 2022/11/05.
//  
//

import SwiftUI
import SplatNet3

struct RecordsView: View {
//    @StateObject var records: RecordService = RecordService()
    
    var body: some View {
        ScrollView(content: {
//            LazyVGrid(columns: Array(repeating: .init(.flexible(maximum: 197.5)), count: 2), content: {
//                if #available(iOS 16.0, *) {
//                    ChartView(destination: {
//                        XBarChartView(title: .CoopHistory_Available, chartData: records.totals.bossCounts)
//                    }, content: {
//                        GrizzcoRecordCard(bundle: .Solo, data: records.totals.bossCounts)
//                    })
//                    ChartView(destination: {
//                        XBarChartView(title: .CoopHistory_Enemy, chartData: records.totals.bossKillCounts)
//                    }, content: {
//                        GrizzcoRecordCard(bundle: .Solo, data: records.totals.bossKillCounts)
//                    })
//                } else {
//                    GrizzcoRecordCard(bundle: .Solo, data: records.totals.bossCounts)
//                    GrizzcoRecordCard(bundle: .Solo, data: records.totals.bossKillCounts)
//                }
//            })
//            LazyVGrid(columns: Array(repeating: .init(.flexible(maximum: 197.5 * 2)), count: 1), content: {
//                ForEach(records.results, content: { record in
//                    GrizzcoStageCard(data: record)
//                })
//            })
        })
        .padding(.horizontal)
        .navigationBarTitleDisplayMode(.inline)
        .navigationTitle(Text(bundle: .Record_Title))
    }
}

struct RecordsView_Previews: PreviewProvider {
    static var previews: some View {
        RecordsView()
    }
}
