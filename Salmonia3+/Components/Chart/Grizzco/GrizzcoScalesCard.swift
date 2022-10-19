//
//  GrizzcoScalesCard.swift
//  Salmonia3+
//
//  Created by devonly on 2022/10/19.
//

import SwiftUI
import SplatNet3

struct GrizzcoScaleCard: View {
    @ObservedObject var scale: Grizzco.ScaleData

    var body: some View {
        ZStack(alignment: .center, content: {
            Color.black.opacity(0.7)
            VStack(alignment: .leading, spacing: 0, content: {
                Text(bundle: .CoopHistory_Scale)
                    .font(systemName: .Splatfont, size: 12)
                    .frame(maxWidth: .infinity, height: 20, alignment: .leading)
                LazyVGrid(columns: Array(repeating: .init(.fixed(40)), count: 3), content: {
                    VStack(alignment: .center, spacing: 0, content: {
                        Image(bundle: ScaleType.Bronze)
                            .resizable()
                            .scaledToFit()
                            .frame(width: 25, height: 25, alignment: .center)
                        Text(String(format: "x%d", scale.bronze))
                            .padding(.top, 2)
                    })
                    VStack(alignment: .center, spacing: 0, content: {
                        Image(bundle: ScaleType.Silver)
                            .resizable()
                            .scaledToFit()
                            .frame(width: 25, height: 25, alignment: .center)
                        Text(String(format: "x%d", scale.silver))
                            .padding(.top, 2)
                    })
                    VStack(alignment: .center, spacing: 0, content: {
                        Image(bundle: ScaleType.Gold)
                            .resizable()
                            .scaledToFit()
                            .frame(width: 25, height: 25, alignment: .center)
                        Text(String(format: "x%d", scale.gold))
                            .padding(.top, 2)
                    })
                })
                .padding(.top, 8)
                .padding(.bottom, 2)
            })
            .padding(.vertical, 6)
            .padding(.horizontal, 10)
        })
        .foregroundColor(SPColor.SplatNet3.SPSalmonGreen)
        .font(systemName: .Splatfont2, size: 12)
        .cornerRadius(10, corners: .allCorners)
    }
}

//struct GrizzcoScales_Previews: PreviewProvider {
//    static var previews: some View {
//        GrizzcoScalesCard()
//    }
//}
