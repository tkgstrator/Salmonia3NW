//
//  SchedulesView.swift
//  salmonia3nw
//
//  Created by devonly on 2022/08/25.
//

import SwiftUI
import RealmSwift
import SplatNet3

struct SchedulesView: View {
    @ObservedResults(
        RealmCoopSchedule.self,
        filter: NSPredicate(format: "rule = %@", SplatNet2.Rule.REGULAR.rawValue)
        //        sortDescriptor: SortDescriptor(keyPath: "playTime", ascending: false)
    ) var schedules
    @State private var selection: SplatNet2.Rule = SplatNet2.Rule.REGULAR

    var body: some View {
        NavigationView(content: {
            List(content: {
                TypePicker<SplatNet2.Rule>(selection: $selection)
                ForEach(schedules.reversed()) { schedule in
                    NavigationLinker(destination: {
                        ResultsView(results: schedule.results)
                    }, label: {
                        ScheduleView(schedule: schedule)
                            .badge(schedule.results.count)
                    })
                }
            })
            .navigationTitle(Text(localizedText: "TAB_SCHEDULE"))
            .navigationBarTitleDisplayMode(.inline)
            .onChange(of: selection, perform: { newValue in
                $schedules.filter = NSPredicate(format: "rule = %@", selection.rawValue)
            })
            .listStyle(.plain)
        })
        .navigationViewStyle(.split)
    }
}

struct SchedulesView_Previews: PreviewProvider {
    static var previews: some View {
        SchedulesView()
    }
}
