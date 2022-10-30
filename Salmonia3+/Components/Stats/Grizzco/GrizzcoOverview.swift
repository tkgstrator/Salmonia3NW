//
//  GrizzcoOverview.swift
//  Salmonia3+
//
//  Created by devonly on 2022/10/30.
//

import SwiftUI
import SwiftUIX

struct GrizzcoOverview: View {
    @ObservedObject var stats: StatsService

    var body: some View {
        PaginationView(axis: .horizontal, showsIndicators: false, content: {
            GrizzcoAverageView(data: stats.average)
                .tag(0)
            GrizzcoSpecialView(data: stats.special)
                .tag(1)
        })
        .cyclesPages(true)
        .initialPageIndex(0)
        .frame(maxWidth: .infinity, height: 160, alignment: .bottom)
    }
}

//struct GrizzcoOverview_Previews: PreviewProvider {
//    static var previews: some View {
//        GrizzcoOverview()
//    }
//}
