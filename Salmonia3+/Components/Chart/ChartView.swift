//
//  ChartView.swift
//  Salmonia3+
//
//  Created by devonly on 2022/10/09.
//

import SwiftUI
import SwiftUICharts

struct ChartView: View {
    var body: some View {
        ScrollView(content: {
            LazyVGrid(columns: Array(repeating: .init(.flexible()), count: 3), content: {
                PieChartView(data: [8,23,54,32], title: "Title", legend: "Legendary", form: ChartForm.medium, dropShadow: false)
                LineChartView(data: [8,23,54,32], title: "Title", legend: "Legendary", form: ChartForm.medium, dropShadow: false)
                LineChartView(data: [8,23,54,32], title: "Title", legend: "Legendary", form: ChartForm.medium, dropShadow: false)
                BarChartView(data: ChartData(points: [8,23,54,32,12,37,7,23,43]), title: "Title", legend: "Legendary", form: ChartForm.medium, dropShadow: false, animatedToBack: true)
                SingleChartView(max: 100, min: 30, avg: 45, title: Text(bundle: .CoopHistory_RescueCount))
            })
        })
    }
}

struct ChartView_Previews: PreviewProvider {
    static var previews: some View {
        ChartView()
            .previewLayout(.fixed(width: 600, height: 600))
            .preferredColorScheme(.dark)
    }
}
