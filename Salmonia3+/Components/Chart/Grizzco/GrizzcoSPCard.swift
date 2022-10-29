//
//  SingleChartView.swift
//  Salmonia3+
//
//  Created by devonly on 2022/10/09.
//

import SwiftUI
import SplatNet3

struct GrizzcoSPCard: View {
    @Environment(\.colorScheme) var colorScheme: ColorScheme
    let specials: [Grizzco.SpecialData]

    public init(specials: [Grizzco.SpecialData]) {
        self.specials = specials
    }
    
    var body: some View {
        ZStack(alignment: .center, content: {
            SPColor.SplatNet2.SPRed
            VStack(alignment: .center, spacing: 0, content: {
                Text(bundle: .MyOutfits_Special)
                    .font(systemName: .Splatfont2, size: 13)
                    .foregroundColor(.white)
                    .shadow(color: Color.black, radius: 0, x: 1, y: 1)
                Spacer()
                LazyVGrid(columns: Array(repeating: .init(.flexible(), alignment: .leading), count: 3), content: {
                    ForEach(specials, id: \.specialId) { special in
                        HStack(content: {
                            Image(bundle: special.specialId)
                                .resizable()
                                .scaledToFit()
                                .frame(width: 23, height: 23, alignment: .center)
                                .background(RoundedRectangle(cornerRadius: 4).fill(special.color))
                            Spacer()
                            Text(String(format: "%.2f%%", special.percent))
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
