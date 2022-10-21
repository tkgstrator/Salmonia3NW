//
//  ResultsView.swift
//  Salmonia3+
//
//  Created by devonly on 2022/09/16.
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
                    if let startTime = schedule.startTime {
                        NavigationLinker(destination: {
                            ScheduleStatsView(startTime: startTime)
                        }, label: {
                            ScheduleView(schedule: schedule)
                        })
                        .listRowInsets(EdgeInsets())
                        .listRowSeparator(.hidden)
                    } else {
                        ScheduleView(schedule: schedule)
                            .listRowInsets(EdgeInsets())
                            .listRowSeparator(.hidden)
                    }
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
                    Image(bundle: .Update)
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

private extension View {
    /// 下に引っ張って更新を表示する
    func pullToRefresh(enabled: Bool) -> some View {
        self.overlay(enabled ? AnyView(PullToRefreshView()) : AnyView(EmptyView()))
    }
}

/// リザルトがなにもないときに下スワイプで取得できることを表示する
private struct PullToRefreshView: View {
    @State private var value: CGFloat = 0

    var body: some View {
        GeometryReader(content: { geometry in
            Text("↓")
                .font(systemName: .Splatfont, size: 34)
                .position(x: geometry.center.x, y: 80 + value)
            Text(bundle: .Common_PullToRefresh)
                .font(systemName: .Splatfont, size: 24)
                .multilineTextAlignment(.center)
                .position(x: geometry.center.x, y: 180)
        })
        .onAppear(perform: {
            withAnimation(.easeInOut(duration: 0.5).repeatForever()) {
                value = 50
            }
        })
    }
}
