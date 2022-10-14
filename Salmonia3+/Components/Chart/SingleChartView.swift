//
//  SingleChartView.swift
//  Salmonia3+
//
//  Created by devonly on 2022/10/09.
//

import SwiftUI
import SwiftUICharts
import SplatNet3

enum ChartType: CaseIterable {
    /// 個人記録
    case Solo
    /// チーム記録
    case Team
    /// なし
    case None
}

struct SingleChartView: View {
    @Environment(\.colorScheme) var colorScheme: ColorScheme
    @ObservedObject var data: ChartData
    @State private var scale: Double = .zero
    public var title: Text
    public var valueSpecifier: String

    public init(
        value: [Double],
        title: Text,
        valueSpecifier: String? = "%.1f"
    ) {
        self.data = ChartData(points: value)
        self.title = title
        self.valueSpecifier = valueSpecifier!
    }

    let colors: [Color] = [
        SPColor.SplatNet3.SPBlue,
        SPColor.SplatNet3.SPRed
    ]

    var body: some View {
        ZStack(alignment: .center, content: {
            RoundedRectangle(cornerRadius: 20)
                .fill(self.colorScheme == .dark ? .black : .white)
                .shadow(color: .primary, radius: 4)
            Spacer()
            VStack(alignment: .leading, spacing: 8, content: {
                self.title
                    .font(.title3)
                    .bold()
                    .foregroundColor(.primary)
                    .padding([.horizontal, .top])
                Doughnut(data: DoughnutChartData(values: data.onlyPoints().map({ Int($0) })))
                    .padding()
            })
        })
        .aspectRatio(200/240, contentMode: .fit)
    }
}

extension View {
    func animation(for number: Double) -> some View {
        self.modifier(AnimatableNumberModifier(number: number))
    }
}

extension Image {
    init(bundle: ChartType) {
        switch bundle {
        case .Solo:
            self.init(bundle: ButtonType.Solo)
        case .Team:
            self.init(bundle: ButtonType.Team)
        case .None:
            self.init(bundle: ButtonType.Solo)
        }
    }
}

struct SingleChartView_Previews: PreviewProvider {
    static var previews: some View {
        LazyVGrid(columns: Array(repeating: .init(.flexible()), count: 2), content: {
            SingleChartView(value: [10, 20, 10, 40, 35, 25, 0], title: Text(bundle: .CoopHistory_JobRatio))
            SingleChartView(value: [10, 20, 10, 40, 35, 25, 0], title: Text(bundle: .CoopHistory_JobRatio))
        })
                .preferredColorScheme(.dark)
    }
}
