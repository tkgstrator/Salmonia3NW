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
        RealmCoopSchedule.self
    ) var schedules
    @AppStorage("CONFIG_SELECTED_RULE") var selection: SplatNet2.Rule = SplatNet2.Rule.REGULAR

    var body: some View {
        List(content: {
            TypePicker<SplatNet2.Rule>(selection: $selection)
            ForEach(schedules.filter(selection).reversed()) { schedule in
                NavigationLinker(destination: {
                    ResultsView(results: schedule.results)
                }, label: {
                    ScheduleView(schedule: schedule)
                })
            }
        })
        .navigationTitle(Text(bundle: .StageSchedule_Title))
        .navigationBarTitleDisplayMode(.inline)
//        .onChange(of: selection, perform: { newValue in
//            $schedules.filter = NSPredicate(format: "rule = %@", selection.rawValue)
//        })
        .listStyle(.plain)
    }
}

fileprivate extension RealmSwift.Results where Element == RealmCoopSchedule {
    func filter(_ condition: SplatNet2.Rule) -> RealmSwift.Results<RealmCoopSchedule> {
        self.filter("rule = %@", condition)
    }
}

struct SchedulesView_Previews: PreviewProvider {
    static var previews: some View {
        SchedulesView()
    }
}
