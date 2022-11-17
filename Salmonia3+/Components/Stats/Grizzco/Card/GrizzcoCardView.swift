//
//  GrizzcoPointCard.swift
//  Salmonia3+
//
//  Created by tkgstrator on 2022/10/12.
//

import SwiftUI
import SplatNet3

struct GrizzcoCardView: View {
    @ObservedObject var data: Grizzco.PointCard

    var body: some View {
        if #available(iOS 16.0, *), !data.chart.entries.isEmpty {
            ChartView(destination: {
                LineChartView(chart: data.chart)
            }, content: {
                GrizzcoPointContent(data: data)
            })
        } else {
            GrizzcoPointContent(data: data)
        }
    }
}

/// イカリング3形式の黄色いポイントカード
private struct GrizzcoPointContent: View {
    @ObservedObject var data: Grizzco.PointCard

    func Contents<T: Numeric>(format: String, value: T?, legend: LocalizedType) -> some View {
        Group(content: {
            HStack(alignment: .bottom, spacing: 0, content: {
                Text(bundle: legend)
                    .font(systemName: .Splatfont2, size: 11)
                    .foregroundColor(Color.black.opacity(0.6))
                    .lineLimit(1)
                    .padding(.trailing, 4)
                    .padding(.bottom, 3)
                    .frame(height: 30, alignment: .top)
                Spacer()
                Text(String(format: format, value))
                    .font(systemName: .Splatfont2, size: 13)
                    .foregroundColor(Color.black)
                    .frame(height: 30, alignment: .bottom)
            })
            .padding(.horizontal, 3)
            DashedLine()
                .stroke(style: StrokeStyle(lineWidth: 2, dash: [4]))
                .foregroundColor(Color.black.opacity(0.3))
                .frame(height: 2)
        })
    }
    
    var body: some View {
        VStack(alignment: .center, spacing: 0, content: {
            ZStack(alignment: .center, content: {
                Color.black
                Text(bundle: .CoopHistory_KumaPointCard)
                    .foregroundColor(SPColor.SplatNet3.SPCoop)
                    .font(systemName: .Splatfont2, size: 12)
            })
            .frame(height: 26)
            .cornerRadius(20, corners: [.topRight, .topLeft])
            ZStack(alignment: .top, content: {
                SPColor.SplatNet3.SPYellow
                VStack(alignment: .center, spacing: 0, content: {
                    ZStack(alignment: .center, content: {
                        Color.black.opacity(0.8)
                        VStack(alignment: .center, spacing: 0, content: {
                            Text(bundle: .CoopHistory_RegularPoint)
                                .font(systemName: .Splatfont2, size: 11)
                                .frame(maxWidth: .infinity, height: 11, alignment: .leading)
                            Text(String(format: "%dp", data.kumaPoint))
                                .font(systemName: .Splatfont2, size: 20)
                                .frame(maxWidth: .infinity, height: 24, alignment: .trailing)
                        })
                        .foregroundColor(SPColor.SplatNet3.SPYellow)
                        .padding(.vertical, 5)
                        .padding(.horizontal, 7)
                    })
                    .frame(height: 45)
                    .cornerRadius(13, corners: .allCorners)
                    .padding(.bottom, 8)
                    Contents(format: "%d", value: data.shiftWorked, legend: .CoopHistory_PlayCount)
                    Contents(format: "%d", value: data.goldenIkuraNum, legend: .CoopHistory_GoldenDeliverCount)
                    Contents(format: "%d", value: data.ikuraNum, legend: .CoopHistory_DeliverCount)
                    Contents(format: "%d", value: data.defeatedCounts, legend: .Common_Defeated_Sakelien_Count)
                    Contents(format: "%d", value: data.bossKillCounts, legend: .CoopHistory_DefeatBossCount)
                    Contents(format: "%d", value: data.helpCount, legend: .CoopHistory_RescueCount)
                    Contents(format: "%d", value: data.deathCount, legend: .Common_Death_Count)
                    Contents(format: "%d", value: data.kumaPoint, legend: .CoopHistory_TotalPoint)
                })
                .padding(6)
                .padding(.bottom, 20)
            })
            .cornerRadius(20, corners: [.bottomLeft, .bottomRight])
        })
    }
}

struct TabSideArray: View {
    var body: some View {
        HStack(alignment: .center, spacing: nil, content: {
            Text("←")
            Spacer()
            Text("→")
        })
        .foregroundColor(Color.white)
        .font(systemName: .Splatfont, size: 22)
        .frame(maxWidth: 400)
    }
}
