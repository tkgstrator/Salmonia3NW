//
//  ResultsView.swift
//  Salmonia3+
//
//  Created by devonly on 2022/09/16.
//

import SwiftUI
import RealmSwift
import SplatNet3

/// リザルトがなにもないときに下スワイプで取得できることを表示する
private struct ResultsEmpty: View {
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

struct ResultsView: View {
    @StateObject var session: Session = Session()
    @ObservedResults(
        RealmCoopSchedule.self,
        filter: NSPredicate(format: "mode = %@", ModeType.CoopHistory_Regular.mode),
        sortDescriptor: SortDescriptor(keyPath: "startTime", ascending: false)
    ) var schedules
    @State private var selection: ModeType = ModeType.CoopHistory_Regular
    @State private var isModalPresented: Bool = false

    var body: some View {
        List(content: {
            ForEach(schedules) { schedule in
                if !schedule.results.isEmpty {
                    ScheduleView(schedule: schedule)
                    ForEach(schedule.results.sorted(byKeyPath: "playTime", ascending: false)) { result in
                        NavigationLinker(destination: {
                            ResultTabView(results: schedule.results)
                                .environment(\.selection, .constant(result.id))
                        }, label: {
                            ResultView(result: result)
                        })
                    }
                }
            }
        })
        .onChange(of: selection, perform: { newValue in
            $schedules.filter = NSPredicate(format: "mode = %@", selection.mode)
        })
        .refreshable(action: {
            await session.dummy(action: {
                isModalPresented.toggle()
            })
        })
        .fullScreen(isPresented: $isModalPresented, content: {
            ResultLoadingView()
                .environment(\.isModalPresented, $isModalPresented)
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
        .listStyle(.plain)
        .navigationTitle(Text(mode: selection))
        .navigationBarTitleDisplayMode(.inline)
    }
}

