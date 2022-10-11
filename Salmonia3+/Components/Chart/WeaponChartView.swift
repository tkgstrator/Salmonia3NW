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
            RoundedRectangle(cornerRadius: 20)
                .fill(self.colorScheme == .dark ? .black : .white)
                .shadow(color: .primary, radius: 2, x: 0, y: 0)
            VStack(alignment: .leading, content: {
                VStack(alignment: .leading, spacing: 8, content: {
                    self.title
                        .font(.title3)
                        .bold()
                        .lineLimit(1)
                        .foregroundColor(.primary)
                })
                .padding([.leading, .top])
                Spacer()
                HStack(alignment: .center, spacing: 0, content: {
                    LazyHGrid(rows: Array(repeating: .init(.flexible(maximum: 40)), count: 4), content: {
                        ForEach(weaponList, id: \.rawValue) { weaponId in
                            let index: Int = weaponList.firstIndex(of: weaponId) ?? 0
                            Image(bundle: weaponId)
                                .resizable()
                                .scaledToFit()
                                .background(RoundedRectangle(cornerRadius: 4).fill(colors[index]))
                        }
                    })
                    Spacer()
                    Doughnut(data: data)
                })
                .font(.callout)
                .padding([.horizontal, .bottom])
                .padding(.top, 8)
                .clipShape(RoundedRectangle(cornerRadius: 20))
            })
        })
        .padding([.horizontal])
        .aspectRatio(340/200, contentMode: .fit)
    }
}

struct WeaponChartView_Previews: PreviewProvider {
    static var previews: some View {
        WeaponChartView(data: [10, 20, 30, 40], weaponList: [.Charger_Long, .Saber_Lite, .Maneuver_Normal, .Slosher_Bathtub], title: Text("Special Weapon"))
            .preferredColorScheme(.dark)
    }
}
