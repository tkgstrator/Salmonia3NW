//
//  FailureChartView.swift
//  Salmonia3+
//
//  Created by devonly on 2022/10/09.
//

import SwiftUI
import SwiftUICharts
import SplatNet3

struct FailureChartView: View {
    @Environment(\.colorScheme) var colorScheme: ColorScheme
    @ObservedObject var data: DoughnutChartData
    @State private var scale: Double = .zero
    public var valueSpecifier: String

    let colors: [Color] = [
        SPColor.SplatNet3.SPBlue,
        SPColor.SplatNet3.SPRed,
        SPColor.SplatNet3.SPYellow,
        SPColor.SplatNet3.SPSalmonGreen,
    ]

    let titles: [LocalizedType] = [
        .CoopHistory_Gj,
        .CoopHistory_Wave1,
        .CoopHistory_Wave2,
        .CoopHistory_Wave3,
    ]

    var ratio: Double {
        let values: [Int] = data.values.map({ $0.value })
        let total: Int = values.reduce(0, +)
        if values.count != 4 {
            return .zero
        }
        return Double(values[0] * 3 + values[2] * 2 + values[1] * 1) / Double(total)
    }

    public init(
        data: [Int]?,
        valueSpecifier: String? = "%.2f%") {
            self.data = DoughnutChartData(values: data, colors: colors)
            self.valueSpecifier = valueSpecifier!
        }

    var body: some View {
        ZStack(alignment: .center, content: {
            RoundedRectangle(cornerRadius: 20)
                .fill(self.colorScheme == .dark ? .black : .white)
                .shadow(color: .primary, radius: 2, x: 0, y: 0)
            VStack(alignment: .leading, content: {
                VStack(alignment: .leading, spacing: 8, content: {
                    Text(bundle: .CoopHistory_AverageClearWaves)
                        .font(.title3)
                        .bold()
                        .lineLimit(1)
                        .foregroundColor(.primary)
                })
                .padding([.leading, .top])
                Spacer()
                HStack(alignment: .center, spacing: 0, content: {
                    VStack(alignment: .leading, spacing: nil, content: {
                        let titles: [LocalizedType] = [
                            .CoopHistory_Clear,
                            .CoopHistory_Wave1,
                            .CoopHistory_Wave2,
                            .CoopHistory_Wave3,
                        ]
                        ForEach(titles, id: \.rawValue) { title in
                            let index: Int = titles.firstIndex(of: title) ?? 0
                            HStack(content: {
                                RoundedRectangle(cornerRadius: 4)
                                    .fill(colors[index])
                                    .frame(width: 24, height: 24, alignment: .center)
                                Text(bundle: title)
                                    .font(.system(size: 20, design: .monospaced))
                            })
                        }
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

struct FailureChartView_Previews: PreviewProvider {
    static var previews: some View {
        FailureChartView(data: [30, 5, 3, 1, 3])
            .preferredColorScheme(.dark)
    }
}
