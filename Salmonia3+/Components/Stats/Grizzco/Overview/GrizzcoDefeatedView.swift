//
//  GrizzcoDefeatedView.swift
//  Salmonia3+
//
//  Created by devonly on 2022/11/14.
//

import SwiftUI
import SplatNet3

struct GrizzcoDefeatedView: View {
    @Environment(\.colorScheme) var colorScheme: ColorScheme

    var body: some View {
        ZStack(alignment: .center, content: {
            SPColor.SplatNet2.SPRed
            VStack(alignment: .center, spacing: 0, content: {
                Text(bundle: .Common_Defeated_Ratio)
                    .font(systemName: .Splatfont2, size: 13)
                    .foregroundColor(.white)
                    .shadow(color: Color.black, radius: 0, x: 1, y: 1)
                Spacer()
                LazyVGrid(columns: Array(repeating: .init(.flexible(), alignment: .center), count: 5), content: {
                    ForEach(SakelienType.allCases) { sakelienId in
                        HStack(content: {
                            Image(bundle: sakelienId)
                                .resizable()
                                .scaledToFit()
                                .frame(width: 23, height: 23, alignment: .center)
                                .background(RoundedRectangle(cornerRadius: 4).fill(SPColor.SplatNet3.SPBackground))
//                            Spacer()
//                            Text(String(format: "%.2f%%", entry.percent))
//                                .font(systemName: .Splatfont2, size: 14)
//                                .foregroundColor(SPColor.SplatNet2.SPWhite)
//                                .shadow(color: Color.black, radius: 0, x: 1, y: 1)
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


struct GrizzcoDefeatedView_Previews: PreviewProvider {
    static var previews: some View {
        GrizzcoDefeatedView()
    }
}
