//
//  Doughnut.swift
//  Salmonia3+
//
//  Created by devonly on 2022/10/09.
//

import SwiftUI
import SplatNet3

struct Doughnut: View {
    @ObservedObject var data: DoughnutChartData

    var body: some View {
        GeometryReader(content: { geometry in
            let width: CGFloat = geometry.width * 0.25
            let lineWidth: CGFloat = 1.2
            ZStack(alignment: .center, content: {
                ForEach(data.values) { value in
                    let index: Int = data.values.firstIndex(where: { $0.id == value.id }) ?? 0
                    ZStack(content: {
//                        Arc(from: index == 0 ? 0.0 : data.values[index - 1].percent, to: value.percent)
                        Circle()
                            .trim(from: index == 0 ? 0.0 : data.values[index - 1].percent, to: value.percent)
                            .stroke(value.color, lineWidth: width)
                            .rotationEffect(.degrees(-90))
                            .padding(width * 0.5)
                            .shadow(color: .primary, radius: 0, x: lineWidth, y: lineWidth)
                            .shadow(color: .primary, radius: 0, x: -lineWidth, y: lineWidth)
                            .shadow(color: .primary, radius: 0, x: -lineWidth, y: -lineWidth)
                            .shadow(color: .primary, radius: 0, x: lineWidth, y: -lineWidth)
                        Circle()
                            .trim(from: index == 0 ? 0.0 : data.values[index - 1].percent, to: value.percent)
                            .stroke(value.color, lineWidth: width)
                            .rotationEffect(.degrees(-90))
                            .padding(width * 0.5)
                    })
                }
            })
        })
        .scaledToFit()
        .onAppear(perform: {
            withAnimation(.easeInOut(duration: 1.0)) {
                data.calc()
            }
        })
    }
}

struct Doughnut_Previews: PreviewProvider {
    static var previews: some View {
        Doughnut(data: DoughnutChartData(values: [10, 20, 30, 40, 50, 60, 70]))
            .previewLayout(.fixed(width: 400, height: 400))
            .preferredColorScheme(.dark)
    }
}
