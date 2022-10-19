//
//  WeaponChartView.swift
//  Salmonia3+
//
//  Created by devonly on 2022/10/09.
//

import SwiftUI
import SwiftUICharts
import SplatNet3

struct KingChartView: View {
    @Environment(\.colorScheme) var colorScheme: ColorScheme
    @ObservedObject var data: DoughnutChartData
    @State private var scale: Double = .zero
    public var title: Text

    public var valueSpecifier: String

    let colors: [Color] = [
        SPColor.SplatNet3.SPBlue,
        SPColor.SplatNet3.SPRed,
    ]

    var ratio: Double {
        let total: Int = data.values.map({ $0.value }).reduce(0, +)
        guard let clear: Int = data.values.first?.value else {
            return .zero
        }

        if total == .zero {
            return .zero
        }

        return Double(clear) / Double(total) * 100
    }

    public init(
        data: [Int]?,
        title: Text,
        valueSpecifier: String? = "%.1f%%") {
            self.data = DoughnutChartData(values: data, colors: colors)
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
                    VStack(alignment: .leading, spacing: nil, content: {
                        HStack(content: {
                            RoundedRectangle(cornerRadius: 4)
                                .fill(SPColor.SplatNet3.SPBlue)
                                .frame(width: 24, height: 24, alignment: .center)
                            Text(bundle: .CoopHistory_Gj)
                                .font(.system(size: 20, design: .monospaced))
                        })
                        HStack(content: {
                            RoundedRectangle(cornerRadius: 4)
                                .fill(SPColor.SplatNet3.SPRed)
                                .frame(width: 24, height: 24, alignment: .center)
                            Text(bundle: .CoopHistory_Ng)
                                .font(.system(size: 20, design: .monospaced))
                        })
                        Spacer()
                    })
                    Spacer()
                    Doughnut(data: data)
                        .overlay(
                            Text(String(format: valueSpecifier, ratio))
                                .font(.system(size: 18, design: .monospaced))
                        )
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

struct KingChartView_Previews: PreviewProvider {
    static var previews: some View {
        KingChartView(data: [30, 5], title: Text(bundle: .CoopHistory_ExWave))
            .preferredColorScheme(.dark)
    }
}
