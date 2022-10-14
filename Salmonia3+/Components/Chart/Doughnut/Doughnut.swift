//
//  Doughnut.swift
//  Salmonia3+
//
//  Created by devonly on 2022/10/09.
//

import SwiftUI
import SplatNet3

struct DoughnutData: Identifiable {
    let id: UUID = UUID()
    let color: Color
    let value: Int
    var percent: Double = 0

    init(value: Int, color: Color) {
        self.value = value
        self.color = color
    }
}

class DoughnutChartData: ObservableObject {
    @Published var values: [DoughnutData] = []

    init(values: [Int]?, colors: [Color]) {
        guard let values = values else {
            return
        }
        
        self.values = zip(values, colors).map({ DoughnutData(value: $0.0, color: $0.1) })
    }

    init(values: [Int]?) {
        guard let values = values else {
            return
        }
        
        let colors: [Color] = Array([
            SPColor.SplatNet3.SPPink,
            SPColor.SplatNet3.SPOrange,
            SPColor.SplatNet3.SPYellow,
            SPColor.SplatNet3.SPSalmonGreen,
            SPColor.SplatNet3.SPGreen,
            SPColor.SplatNet3.SPBlue,
            SPColor.SplatNet3.SPPurple,
        ].prefix(values.count))

        self.values = zip(values, colors).map({ DoughnutData(value: $0.0, color: $0.1) })
    }

    func calc() {
        let total: Double = Double(values.map({ $0.value }).reduce(0, +))
        var sum: Double = .zero

        for (index, value) in values.enumerated() {
            sum += Double(value.value) / total
            values[index].percent = sum
        }
    }
}

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
