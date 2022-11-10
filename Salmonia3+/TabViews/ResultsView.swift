//
//  ResultsView.swift
//  Salmonia3+
//
//  Created by tkgstrator on 2022/09/16.
//

import SwiftUI
import RealmSwift
import SplatNet3

struct ResultsView: View {
    @ObservedResults(
        RealmCoopSchedule.self,
        filter: NSPredicate(format: "mode = %@", ModeType.CoopHistory_Regular.mode),
        sortDescriptor: SortDescriptor(keyPath: "startTime", ascending: false)
    ) var schedules
    @State private var selection: ModeType = ModeType.CoopHistory_Regular

    var body: some View {
        List(content: {
            ForEach(schedules) { schedule in
                if !schedule.results.isEmpty {
                    ScheduleView(schedule: schedule)
                        .listRowInsets(EdgeInsets())
                        .listRowSeparator(.hidden)
                    ForEach(schedule.results.sorted(byKeyPath: "playTime", ascending: false)) { result in
                        NavigationLinker(destination: {
                            ResultTabView(results: schedule.results)
                                .environment(\.selection, .constant(result.id))
                        }, label: {
                            ResultView(result: result)
                        })
                        .listRowInsets(EdgeInsets())
                        .listRowSeparator(.hidden)
                    }
                }
            }
        })
        .pullToRefresh(enabled: schedules.isEmpty)
        .onChange(of: selection, perform: { newValue in
            /// モードが切り替わったときにフィルターをかける
            $schedules.filter = NSPredicate(format: "mode = %@", selection.mode)
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
                    Image(bundle: .Swap)
                        .renderingMode(.template)
                        .resizable()
                        .scaledToFit()
                        .frame(width: 30, height: 30, alignment: .center)
                        .foregroundColor(.primary)
                })
            })
        })
        .listStyle(.plain)
        .navigationTitle(Text(mode: selection))
        .navigationBarTitleDisplayMode(.inline)
    }
}

