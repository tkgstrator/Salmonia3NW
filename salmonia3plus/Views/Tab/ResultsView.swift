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
//    @StateObject private var session: Session = Session()
    @State private var isPresented: Bool = false

    var body: some View {
        List(content: {
            ForEach(schedules, id: \.self, content: { schedule in
                ForEach(schedule.results, content: { result in
                    ResultElement(result: result)
                        .listRowInsets(EdgeInsets())
                        .listRowSeparator(.hidden)
                })
            })
        })
        .listStyle(.plain)
        .refreshable(action: {
            isPresented.toggle()
        })
//        .fullScreen(isPresented: $isPresented, session: session)
    }
}

struct ResultsView_Previews: PreviewProvider {
    static var previews: some View {
        ResultsView()
    }
}
