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
        filter: NSPredicate(format: "mode = %@", ModeType.CoopHistory_Regular.mode),
        sortDescriptor: SortDescriptor(keyPath: "startTime", ascending: false)
    ) var schedules
    @State private var selection: ModeType = ModeType.CoopHistory_Regular

    var body: some View {
        List(content: {
            ForEach(schedules) { schedule in
                if let startTime = schedule.startTime {
                    NavigationLinker(destination: {
                        ScheduleStatsView(startTime: startTime)
                    }, label: {
                        ScheduleView(schedule: schedule)
                    })
                } else {
                    ScheduleView(schedule: schedule)
                }
            }
        })
        .onChange(of: selection, perform: { newValue in
            $schedules.filter = NSPredicate(format: "mode = %@", newValue.mode)
        })
        .refreshableResult()
        .toolbar(content: {
            ToolbarItem(placement: .navigationBarLeading, content: {
                SPWebButton()
            })
            ToolbarItem(placement: .navigationBarTrailing, content: {
                Button(action: {
                    selection.next()
                }, label: {
                    Image(bundle: .Update)
                        .renderingMode(.template)
                        .resizable()
                        .scaledToFit()
                        .frame(width: 30, height: 30, alignment: .center)
                        .foregroundColor(.primary)
                })
            })
        })
        .navigationBarTitleDisplayMode(.inline)
        .navigationTitle(Text(mode: selection))
        .listStyle(.plain)
    }
}

//fileprivate extension RealmSwift.Results where Element == RealmCoopSchedule {
//    func filter(_ condition: SplatNet2.Rule) -> RealmSwift.Results<RealmCoopSchedule> {
//        self.filter("rule = %@", condition)
//    }
//}

struct SchedulesView_Previews: PreviewProvider {
    static var previews: some View {
        SchedulesView()
    }
}
