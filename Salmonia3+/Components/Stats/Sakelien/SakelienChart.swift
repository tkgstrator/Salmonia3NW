//
//  SakelienChart.swift
//  Salmonia3+
//
//  Created by tkgstrator on 2022/10/21.
//

import SwiftUI
import SplatNet3
import Charts

@available(iOS 16.0, *)
struct SakelienChart: View {
    @ObservedObject var data: Grizzco.BossData

    var body: some View {
        BarChartView(chart: data.chart)
    }
}
