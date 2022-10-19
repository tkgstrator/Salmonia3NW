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
    @State private var scale: Double = .zero
    public var title: Text
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
        title: Text,
        valueSpecifier: String? = "%.1f") {
            self.data = DoughnutChartData(values: data)
            self.weaponList = weaponList
            self.title = title
            self.valueSpecifier = valueSpecifier!
        }

    var body: some View {
        ZStack(alignment: .center, content: {
            Color.primary.opacity(0.3)
            HStack(content: {
                Doughnut(data: data)
                    .padding(.top, 27)
                    .padding(.bottom, 8)
            })
        })
        .frame(width: 300, height: 160, alignment: .center)
        .mask(Image(bundle: .Card))
        .clipShape(RoundedRectangle(cornerRadius: 20))
    }
}

struct WeaponChartView_Previews: PreviewProvider {
    static var previews: some View {
        WeaponChartView(data: [10, 20, 30, 40], weaponList: [.Charger_Long, .Saber_Lite, .Maneuver_Normal, .Slosher_Bathtub], title: Text("Special Weapon"))
            .preferredColorScheme(.dark)
    }
}
