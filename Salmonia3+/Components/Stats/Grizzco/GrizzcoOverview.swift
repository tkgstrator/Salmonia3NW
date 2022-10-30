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
    @State private var selection: Int = 0

    var body: some View {
        TabView(selection: $selection, content: {
            GrizzcoAverageView(data: stats.average)
                .tag(0)
            GrizzcoSpecialView(data: stats.special)
                .tag(1)
        })
        .frame(height: 160, alignment: .bottom)
        .tabViewStyle(.page(indexDisplayMode: .never))
        ////        PaginationView(axis: .horizontal, showsIndicators: false, content: {
////        })
//        .cyclesPages(true)
//        .menuIndicator(.hidden)
    }
}

//struct GrizzcoOverview_Previews: PreviewProvider {
//    static var previews: some View {
//        GrizzcoOverview()
//    }
//}
