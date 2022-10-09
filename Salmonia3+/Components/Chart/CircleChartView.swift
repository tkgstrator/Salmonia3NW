//
//  SingleChartView.swift
//  Salmonia3+
//
//  Created by devonly on 2022/10/09.
//

import SwiftUI
import SwiftUICharts
import SplatNet3

struct CircleChartView: View {
    @Environment(\.colorScheme) var colorScheme: ColorScheme
    @ObservedObject var data: DoughnutChartData
    @State private var scale: Double = .zero
    public var title: Text
    public var legend: String?
    public var style: ChartStyle
    public var darkModeStyle: ChartStyle

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
        SPColor.SplatNet3.SPGreen,
        SPColor.SplatNet3.SPBlue,
        SPColor.SplatNet3.SPPurple,
    ]

    public init(
        data: [Int]?,
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
                        ForEach(SpecialType.allCases.dropFirst(), id: \.rawValue) { specialId in
                            let index: Int = (SpecialType.allCases.firstIndex(of: specialId) ?? 1) - 1
                            Image(bundle: specialId)
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

struct CircleChartView_Previews: PreviewProvider {
    static var previews: some View {
        CircleChartView(data: [10, 20, 30, 40, 50, 60, 70], title: Text("Special Weapon"))
            .preferredColorScheme(.dark)
    }
}
