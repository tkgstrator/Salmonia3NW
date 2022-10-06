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
        filter: NSPredicate(format: "rule = %@", RuleType.CoopHistory_Regular.rule)
    ) var schedules
    @State private var selection: RuleType = RuleType.CoopHistory_Regular

    var body: some View {
        List(content: {
            ForEach(schedules.reversed()) { schedule in
                NavigationLinker(destination: {
                    ResultsView(results: schedule.results)
                }, label: {
                    ScheduleView(schedule: schedule)
                })
            }
        })
        .toolbar(content: {
            ToolbarItem(placement: .navigationBarTrailing, content: {
                Button(action: {
                    selection.next()
                }, label: {
                    Image("ButtonType/Update", bundle: .main)
                        .renderingMode(.template)
                        .resizable()
                        .scaledToFit()
                        .frame(width: 30, height: 30, alignment: .center)
                        .foregroundColor(.primary)
                })
            })
        })
        .navigationTitle(Text(rule: selection))
        .navigationBarTitleDisplayMode(.inline)
        .onChange(of: selection, perform: { newValue in
            $schedules.filter = NSPredicate(format: "rule = %@", newValue.rule)
        })
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
