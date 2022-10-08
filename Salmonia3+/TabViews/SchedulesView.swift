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
                NavigationLinker(destination: {
                    EmptyView()
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
        .onChange(of: selection, perform: { newValue in
            $schedules.filter = NSPredicate(format: "mode = %@", newValue.mode)
        })
        .navigationTitle(Text(mode: selection))
        .navigationBarTitleDisplayMode(.inline)
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
