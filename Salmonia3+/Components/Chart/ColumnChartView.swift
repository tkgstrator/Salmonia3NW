//
//  ColumnChartView.swift
//  Salmonia3+
//
//  Created by devonly on 2022/10/11.
//

import SwiftUI
import SwiftUICharts

struct ColumnChartView: View {
    @Environment(\.colorScheme) var colorScheme: ColorScheme
    @ObservedObject var solo: SingleData
    @ObservedObject var team: SingleData
    public var title: Text
    public var valueSpecifier: String

    var frame = CGSize(width: 340, height: 140)

    public init(
        solo: Stats?,
        team: Stats?,
        title: Text,
        dropShadow: Bool? = true,
        valueSpecifier: String? = "%.1f"
    ) {
        self.solo = SingleData(max: solo?.maximum, min: solo?.minimum, avg: solo?.average)
        self.team = SingleData(max: team?.maximum, min: team?.minimum, avg: team?.average)
        self.title = title
        self.valueSpecifier = valueSpecifier!
    }

    public init(
        max: Int?,
        min: Int?,
        avg: Double?,
        title: Text,
        dropShadow: Bool? = true,
        valueSpecifier: String? = "%.1f"
    ) {
        self.solo = SingleData(max: max, min: min, avg: avg)
        self.team = SingleData(max: max, min: min, avg: avg)
        self.title = title
        self.valueSpecifier = valueSpecifier!
    }

    var body: some View {
        ZStack(alignment: .center, content: {
            RoundedRectangle(cornerRadius: 20)
                .fill(self.colorScheme == .dark ? .black : .white)
                .shadow(color: .primary, radius: 2, x: 0, y: 0)
            VStack(alignment: .leading, content: {
                VStack(alignment: .leading, spacing: 0, content: {
                    self.title
                        .font(.title3)
                        .bold()
                        .lineLimit(1)
                        .foregroundColor(.primary)
                })
                .padding([.leading, .top])
                Spacer()
                HStack(alignment: .bottom, spacing: 0, content: {
                    ChartTitle()
                    VStack(alignment: .trailing, spacing: 0, content: {
                        Image(bundle: ChartType.Solo)
                            .resizable()
                            .scaledToFit()
                        ChartValue(maxValue: solo.maxValue, minValue: solo.minValue, avgValue: solo.avgValue)
                    })
                    VStack(alignment: .trailing, spacing: 0, content: {
                        Image(bundle: ChartType.Team)
                            .resizable()
                            .scaledToFit()
                        ChartValue(maxValue: team.maxValue, minValue: team.minValue, avgValue: team.avgValue)
                    })
                })
                .font(.callout)
                .padding([.horizontal, .bottom])
                .clipShape(RoundedRectangle(cornerRadius: 20))
            })
        })
        .padding([.horizontal])
        .aspectRatio(340/130, contentMode: .fit)
    }
}

private struct ChartTitle: View {
    var body: some View {
        VStack(alignment: .leading, spacing: 0, content: {
            Text("Max")
                    .frame(height: 20)
            Text("Min")
                    .frame(height: 20)
            Text("Avg")
                    .frame(height: 20)
        })
        .font(.system(size: 16, design: .monospaced))
    }
}

private struct ChartValue: View {
    @State private var scale: Double = .zero
    let maxValue: Int?
    let minValue: Int?
    let avgValue: Double?

    var body: some View {
        VStack(alignment: .leading, spacing: 0, content: {
            if let maxValue = maxValue, let minValue = minValue, let avgValue = avgValue {
                Color.clear
                    .animation(for: Double(maxValue) * scale)
                    .frame(height: 20)
                Color.clear
                    .animation(for: Double(minValue) * scale)
                    .frame(height: 20)
                Color.clear
                    .animation(for: Double(avgValue) * scale)
                    .frame(height: 20)
            } else {
                Text("-")
                    .frame(maxWidth: .infinity, alignment: .trailing)
                Text("-")
                    .frame(maxWidth: .infinity, alignment: .trailing)
                Text("-")
                    .frame(maxWidth: .infinity, alignment: .trailing)
            }
        })
        .onAppear(perform: {
            withAnimation(.easeInOut(duration: 2.0)) {
                self.scale = 1.0
            }
        })
    }
}

struct ColumnChartView_Previews: PreviewProvider {
    static var previews: some View {
        ScrollView(content: {
            LazyVGrid(columns: Array(repeating: .init(.flexible()), count: 1), content: {
                ColumnChartView(max: 100, min: 40, avg: 60, title: Text(bundle: .CoopHistory_RescuedCount))
            })
            .preferredColorScheme(.dark)
        })
    }
}
