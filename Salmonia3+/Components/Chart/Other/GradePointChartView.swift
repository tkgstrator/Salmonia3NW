//
//  SPLineChartView.swift
//
//
//  Created by devonly on 2022/10/11.
//

import SwiftUI
import SwiftUICharts

public struct GradePointChartView: View {
    @Environment(\.colorScheme) var colorScheme
    @ObservedObject var data: ChartData
    @State private var touchLocation:CGPoint = .zero
    @State private var showIndicatorDot: Bool = false
    public var title: Text
    public var valueSpecifier: String

    public init(data: [Double], title: Text, valueSpecifier: String? = "%.1f") {
        self.data = ChartData(points: data)
        self.title = title
        self.valueSpecifier = valueSpecifier!
    }

    public var body: some View {
        ZStack(alignment: .center, content: {
            RoundedRectangle(cornerRadius: 20)
                .fill(self.colorScheme == .dark ? .black : .white)
                .shadow(color: .primary, radius: 2, x: 0, y: 0)
            VStack(alignment: .leading, spacing: 8, content: {
                self.title
                    .font(.title3)
                    .bold()
                    .foregroundColor(.primary)
                    .padding([.leading, .top])
                HStack(content: {
                    HStack(content: {
                        Text(bundle: .CoopHistory_HighestScore)
                        Spacer()
                        Text(String(format: valueSpecifier, self.data.onlyPoints().max() ?? 0))
                    })
                    .frame(maxWidth: 200)
                })
                .font(.system(size: 16, design: .monospaced))
                .padding([.horizontal])
                GeometryReader(content: { geometry in
                    Line(data: self.data,
                         frame: .constant(geometry.frame(in: .local)),
                         touchLocation: self.$touchLocation,
                         showIndicator: self.$showIndicatorDot,
                         minDataValue: .constant(nil),
                         maxDataValue: .constant(nil)
                    )
                })
                .clipShape(RoundedRectangle(cornerRadius: 20))
            })
        })
        .aspectRatio(340/140, contentMode: .fit)
    }
}

struct LineChartView_Previews: PreviewProvider {
    static var previews: some View {
        GradePointChartView(data: [8,23,54,32,12,37,7,23,43], title: Text("Stats"))
            .preferredColorScheme(.dark)
    }
}
