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

struct SchedulesView: View {
    @ObservedResults(
        RealmCoopSchedule.self,
        filter: NSPredicate(format: "mode = %@", ModeType.REGULAR.rawValue),
        sortDescriptor: SortDescriptor(keyPath: "startTime", ascending: false)
    ) var schedules
    @Environment(\.isModalPresented) var isPresented

    var body: some View {
        List(content: {
            ForEach(schedules, id: \.self, content: { schedule in
                ScheduleElement(schedule: schedule)
                    .listRowInsets(EdgeInsets())
                    .listRowSeparator(.hidden)
            })
        })
        .listStyle(.plain)
        .refreshable(action: {
            await send(action: {
                isPresented.wrappedValue.toggle()
            })
        })
        .showsScrollIndicators()
        .navigationBarTitleDisplayMode(.inline)
        .navigationTitle(Text(bundle: .StageSchedule_Title))
    }

    private func send(action: @escaping () -> Void) async {
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5, execute: {
            action()
        })
    }
}

struct SchedulesView_Previews: PreviewProvider {
    static var previews: some View {
        SchedulesView()
    }
}
