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
        ZStack(alignment: .center, content: {
            ForEach(data.values) { value in
                let index: Int = data.values.firstIndex(where: { $0.id == value.id }) ?? 0
                ZStack(content: {
                    HalfCircle(
                        from: index == 0 ? 0.0 : data.values[index - 1].percent,
                        to: value.percent
                    )
                    .fill(value.color)
                    HalfCircle(
                        from: index == 0 ? 0.0 : data.values[index - 1].percent,
                        to: value.percent
                    )
                    .strokeBorder(Color.white, lineWidth: 2, antialiased: true)
                })
                .rotationEffect(.degrees(-90))
            }
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
    static let colors: [Color] = [
        SPColor.SplatNet3.SPPink,
        SPColor.SplatNet3.SPOrange,
        SPColor.SplatNet3.SPYellow,
        SPColor.SplatNet3.SPSalmonGreen,
    ]

    static var previews: some View {
        Doughnut(data: DoughnutChartData(values: [10, 20, 30, 40, 50, 60, 70], colors: colors))
            .previewLayout(.fixed(width: 400, height: 400))
            .preferredColorScheme(.dark)
    }
}
