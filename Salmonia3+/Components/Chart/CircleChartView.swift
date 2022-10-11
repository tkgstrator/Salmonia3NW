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
    @State private var scale: Double = .zero
    public var title: Text

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
        title: Text,
        legend: String? = nil,
        valueSpecifier: String? = "%.1f") {
            self.data = DoughnutChartData(values: data)
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
                        ForEach(SpecialType.allCases.dropFirst(), id: \.rawValue) { specialId in
                            let index: Int = SpecialType.allCases.dropFirst().firstIndex(of: specialId) ?? 0
                            Image(bundle: specialId)
                                .resizable()
                                .scaledToFit()
                                .background(RoundedRectangle(cornerRadius: 4).fill(colors[index - 1]))
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

struct CircleChartView_Previews: PreviewProvider {
    static var previews: some View {
        SpecialChartView(data: [10, 20, 30, 40, 50, 60, 70], title: Text("Special Weapon"))
            .preferredColorScheme(.dark)
    }
}
