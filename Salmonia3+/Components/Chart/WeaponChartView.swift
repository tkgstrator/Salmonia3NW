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
    public var legend: String?
    public var style: ChartStyle
    public var darkModeStyle: ChartStyle
    public let weaponList: [WeaponType]

    public var formSize:CGSize
    public var dropShadow: Bool
    public var valueSpecifier: String

    var frame = CGSize(width: 180, height: 120)
    private var rateValue: Int?

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
        legend: String? = nil,
        style: ChartStyle = Styles.lineChartStyleOne,
        form: CGSize? = ChartForm.extraLarge,
        rateValue: Int? = 14 ,
        dropShadow: Bool? = true,
        valueSpecifier: String? = "%.1f") {
            self.data = DoughnutChartData(values: data)
            self.title = title
            self.legend = legend
            self.style = style
            self.darkModeStyle = style.darkModeStyle != nil ? style.darkModeStyle! : Styles.lineViewDarkMode
            self.formSize = form!
            frame = CGSize(width: self.formSize.width, height: self.formSize.height * 0.5)
            self.dropShadow = dropShadow!
            self.valueSpecifier = valueSpecifier!
            self.rateValue = rateValue
            self.weaponList = weaponList
        }

    var body: some View {
        ZStack(alignment: .center, content: {
            RoundedRectangle(cornerRadius: 20)
                .fill(self.colorScheme == .dark ? self.darkModeStyle.backgroundColor : self.style.backgroundColor)
                .frame(width: frame.width, height: 240, alignment: .center)
                .shadow(color: self.style.dropShadowColor, radius: self.dropShadow ? 4 : 0)
            VStack(alignment: .leading){
                VStack(alignment: .leading, spacing: 8, content: {
                    self.title
                        .font(.title)
                        .bold()
                        .lineLimit(1)
                        .foregroundColor(self.colorScheme == .dark ? self.darkModeStyle.textColor : self.style.textColor)
                    if let legend = legend {
                        Text(legend)
                            .font(.callout)
                            .foregroundColor(self.colorScheme == .dark ? self.darkModeStyle.legendTextColor : self.style.legendTextColor)
                    }
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
                .padding([.horizontal, .top, .bottom])
                .frame(width: frame.width, height: 180)
                .clipShape(RoundedRectangle(cornerRadius: 20))
            }
            .frame(width: self.formSize.width, height: self.formSize.height)
        })
    }
}

struct WeaponChartView_Previews: PreviewProvider {
    static var previews: some View {
        WeaponChartView(data: [10, 20, 30, 40], weaponList: [.Charger_Long, .Saber_Lite, .Maneuver_Normal, .Slosher_Bathtub], title: Text("Special Weapon"))
            .preferredColorScheme(.dark)
    }
}
