//
//  SingleChartView.swift
//  Salmonia3+
//
//  Created by devonly on 2022/10/09.
//

import SwiftUI
import SwiftUICharts
import SplatNet3

struct GrizzcoSPCard: View {
    @Environment(\.colorScheme) var colorScheme: ColorScheme
    @ObservedObject var data: DoughnutChartData

    public var valueSpecifier: String

    let colors: [Color] = [
        SPColor.SplatNet3.SPPink,
        SPColor.SplatNet3.SPOrange,
        SPColor.SplatNet3.SPYellow,
        SPColor.SplatNet3.SPSalmonGreen,
        SPColor.SplatNet3.SPGreen,
        SPColor.SplatNet3.SPBlue,
        SPColor.SplatNet3.SPPurple,
    ]

    public init(
        data: [Int]?,
        valueSpecifier: String? = "%.1f") {
            self.data = DoughnutChartData(values: data, colors: colors)
            self.valueSpecifier = valueSpecifier!
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
                HStack(alignment: .center, content: {
                    LazyVGrid(columns: Array(repeating: .init(.flexible()), count: 3), content: {
                    let specialList: [SpecialType] = Array(SpecialType.allCases.dropFirst())
                        ForEach(specialList, id: \.rawValue) { specialId in
                            let color: Color = colors[specialList.firstIndex(of: specialId) ?? 0]
                            Label(title: {
                                Text(String(format: "%.2f%%", 99.99))
                                    .font(systemName: .Splatfont2, size: 14)
                                    .foregroundColor(SPColor.SplatNet2.SPWhite)
                                    .shadow(color: Color.black, radius: 0, x: 1, y: 1)
                            }, icon: {
                                Image(bundle: specialId)
                                    .resizable()
                                    .scaledToFit()
                                    .frame(width: 23, height: 23, alignment: .center)
                                    .background(RoundedRectangle(cornerRadius: 4).fill(color))
                            })
                        }
                    })
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
