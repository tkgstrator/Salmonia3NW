//
//  WeaponChartView.swift
//  Salmonia3+
//
//  Created by devonly on 2022/10/09.
//

import SwiftUI
import SwiftUICharts
import SplatNet3

struct WeaponChartView: View {
    @Environment(\.colorScheme) var colorScheme: ColorScheme
    @ObservedObject var data: DoughnutChartData
    public let weaponList: [WeaponType]

    public var valueSpecifier: String

    let colors: [Color] = [
        SPColor.SplatNet3.SPPink,
        SPColor.SplatNet3.SPOrange,
        SPColor.SplatNet3.SPYellow,
        SPColor.SplatNet3.SPSalmonGreen,
    ]

    public init(
        data: [Int]?,
        weaponList: [WeaponType],
        valueSpecifier: String? = "%.1f") {
            self.data = DoughnutChartData(values: data, colors: colors)
            self.weaponList = weaponList
            self.valueSpecifier = valueSpecifier!
        }

    var body: some View {
        ZStack(alignment: .center, content: {
            Color.black.opacity(0.7)
            VStack(alignment: .center, spacing: 0, content: {
                Text(bundle: .MyOutfits_Main)
                    .font(systemName: .Splatfont, size: 13)
                HStack(alignment: .center, content: {
                    LazyHGrid(rows: Array(repeating: .init(.fixed(24)), count: 4), content: {
                        ForEach(weaponList, id: \.rawValue) { weaponId in
                            let color: Color = colors[weaponList.firstIndex(of: weaponId) ?? 0]
                            Image(bundle: weaponId)
                                .resizable()
                                .scaledToFit()
                                .frame(width: 24, height: 24, alignment: .center)
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

struct WeaponChartView_Previews: PreviewProvider {
    static var previews: some View {
        WeaponChartView(data: [10, 20, 30, 40], weaponList: [.Charger_Long, .Saber_Lite, .Maneuver_Normal, .Slosher_Bathtub])
            .preferredColorScheme(.dark)
    }
}
