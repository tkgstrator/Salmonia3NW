//
//  ResultsView.swift
//  Salmonia3+
//  
//  Created by devonly on 2022/11/27
//  Copyright © 2022 Magi Corporation. All rights reserved.
//

import SwiftUI
import RealmSwift
import SplatNet3

struct ResultsView: View {
    @ObservedResults(
        RealmCoopSchedule.self,
        filter: NSPredicate(format: "mode = %@", ModeType.REGULAR.rawValue),
        sortDescriptor: SortDescriptor(keyPath: "startTime", ascending: false)
    ) var schedules
    @Environment(\.isModalPresented) var isPresented

    var body: some View {
        List(content: {
            ForEach(schedules, id: \.self, content: { schedule in
                if !schedule.results.isEmpty {
                    ScheduleElement(schedule: schedule)
                    ForEach(schedule.results.sorted(by: { $0.playTime > $1.playTime }), content: { result in
                        ResultElement(result: result)
                    })
                }
            })
        })
        .listStyle(.plain)
        .refreshable(action: {
            await send(action: {
                isPresented.wrappedValue.toggle()
            })
        })
        .showsScrollIndicators()
        .navigationTitle(Text(bundle: .CoopHistory_History))
    }

    private func send(action: @escaping () -> Void) async {
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5, execute: {
            action()
        })
    }
}

struct ResultsView_Previews: PreviewProvider {
    static var previews: some View {
        ResultsView()
    }
}
