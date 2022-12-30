//
//  ResultTabView.swift
//  Salmonia3+
//  
//  Created by devonly on 2022/12/11
//  Copyright © 2022 Magi Corporation. All rights reserved.
//

import SwiftUI

struct ResultTabView: View {
    @Environment(\.coopResult) var result
    @Environment(\.coopSchedule) var schedule

    var body: some View {
        TabView(content: {
            ForEach(schedule.results.sorted(by: { $0.playTime > $1.playTime }), content: { result in
                ResultView()
                    .id(result.id)
            })
        })
        .tabViewStyle(.page(indexDisplayMode: .never))
    }
}

struct ResultTabView_Previews: PreviewProvider {
    static var previews: some View {
        ResultTabView()
    }
}
