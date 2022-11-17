//
//  GrizzcoHighCard.swift
//  Salmonia3+
//
//  Created by tkgstrator on 2022/10/19.
//

import SwiftUI
import SplatNet3

struct GrizzcoHighScoreView: View {
    @ObservedObject var data: Grizzco.HighScore

    var body: some View {
        if #available(iOS 16.0, *), !data.chart.entries.isEmpty {
            ChartView(destination: {
                LineChartView(chart: data.chart)
            }, content: {
                GrizzcoGradeContent(data: data)
            })
        } else {
            GrizzcoGradeContent(data: data)
        }
    }
}

/// イカリング3形式の最高値表示カード
private struct GrizzcoGradeContent: View {
    let data: Grizzco.HighScore
    
    var body: some View {
        ZStack(alignment: .center, content: {
            Color.black.opacity(0.7)
            VStack(alignment: .leading, spacing: 0, content: {
                HStack(alignment: .center, spacing: 0, content: {
                    if let maxGradePoint = data.maxGradePoint, let maxGrade = data.maxGrade {
                        Text(maxGrade.localizedText)
                        Text(String(format: " %d", maxGradePoint))
                    } else {
                        Text("-")
                    }
                    Spacer()
                })
                .padding(.vertical, 5)
                ZStack(alignment: .leading, content: {
                    GeometryReader(content: { geometry in
                        RoundedRectangle(cornerRadius: 5)
                            .fill(Color.white.opacity(0.3))
                        if let maxGradePoint = data.maxGradePoint, let maxGrade = data.maxGrade {
                            Rectangle()
                                .fill(SPColor.SplatNet3.SPCoop)
                                .frame(width: geometry.width * (Double(maxGradePoint) / Double(maxGrade == GradeType.Eggsecutive_VP ? 999 : 100)))
                        }
                    })
                })
                .clipShape(RoundedRectangle(cornerRadius: 5))
                .frame(height: 10)
                .padding(.bottom, 15)
                Text(bundle: .CoopHistory_AverageClearWaves)
                Text(String(format: " %.2f", data.averageWaveCleared))
                    .font(systemName: .Splatfont2, size: 20)
                    .frame(maxWidth: .infinity, height: 20, alignment: .trailing)
            })
            .padding(.vertical, 6)
            .padding(.horizontal, 10)
        })
        .foregroundColor(SPColor.SplatNet3.SPSalmonGreen)
        .font(systemName: .Splatfont2, size: 12)
        .cornerRadius(10, corners: .allCorners)
    }
}
