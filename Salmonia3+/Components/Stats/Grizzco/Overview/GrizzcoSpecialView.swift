//
//  SingleChartView.swift
//  Salmonia3+
//
//  Created by tkgstrator on 2022/10/09.
//

import SwiftUI
import SplatNet3

struct GrizzcoSpecialView: View {
    @Environment(\.colorScheme) var colorScheme: ColorScheme
    @ObservedObject var chart: Grizzco.SpecialData

    var body: some View {
        ZStack(alignment: .center, content: {
            SPColor.SplatNet2.SPRed
            VStack(alignment: .center, spacing: 0, content: {
                Text(bundle: .Common_Supplied_Special_Prob)
                    .font(systemName: .Splatfont2, size: 13)
                    .foregroundColor(.white)
                    .shadow(color: Color.black, radius: 0, x: 1, y: 1)
                Spacer()
                LazyVGrid(columns: Array(repeating: .init(.flexible(), alignment: .leading), count: 3), content: {
                    ForEach(chart.entries, id: \.id) { entry in
                        HStack(content: {
                            Image(bundle: entry.key)
                                .resizable()
                                .scaledToFit()
                                .frame(width: 23, height: 23, alignment: .center)
                                .background(RoundedRectangle(cornerRadius: 4).fill(SPColor.SplatNet3.SPBackground))
                            Spacer()
                            Text(String(format: "%.2f%%", entry.percent))
                                .font(systemName: .Splatfont2, size: 14)
                                .foregroundColor(SPColor.SplatNet2.SPWhite)
                                .shadow(color: Color.black, radius: 0, x: 1, y: 1)
                        })
                    }
                })
            })
            .padding(.top, 27)
            .padding(.bottom, 15)
            .padding(.horizontal)
        })
        .frame(width: 300, height: 160, alignment: .center)
        .mask(Image(bundle: .Card).resizable().scaledToFill())
        .clipShape(RoundedRectangle(cornerRadius: 20))
    }
}
