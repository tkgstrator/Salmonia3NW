//
//  SingleChartView.swift
//  Salmonia3+
//
//  Created by devonly on 2022/10/09.
//

import SwiftUI
import SwiftUICharts
import SplatNet3

struct SpecialChartView: View {
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
            Color.black.opacity(0.7)
            VStack(alignment: .center, spacing: 0, content: {
                Text(bundle: .MyOutfits_Special)
                    .font(systemName: .Splatfont, size: 13)
                HStack(alignment: .center, content: {
                    LazyHGrid(rows: Array(repeating: .init(.fixed(23)), count: 4), content: {
                    let specialList: [SpecialType] = Array(SpecialType.allCases.dropFirst())
                        ForEach(specialList, id: \.rawValue) { specialId in
                            let color: Color = colors[specialList.firstIndex(of: specialId) ?? 0]
                            Image(bundle: specialId)
                                .resizable()
                                .scaledToFit()
                                .frame(width: 23, height: 23, alignment: .center)
                                .background(RoundedRectangle(cornerRadius: 4).fill(color))
                        }
                    })
                    Spacer()
                    Doughnut(data: data)
                })
            })
            .padding(.top, 27)
            .padding(.bottom, 15)
            .padding(.horizontal)
        })
        .frame(width: 300, height: 180, alignment: .center)
        .mask(Image(bundle: .Card).resizable().scaledToFill())
        .clipShape(RoundedRectangle(cornerRadius: 20))
    }
}

struct CircleChartView_Previews: PreviewProvider {
    static var previews: some View {
        SpecialChartView(data: [10, 20, 30, 40, 50, 60, 70])
            .preferredColorScheme(.dark)
    }
}
