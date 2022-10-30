//
//  GrizzcoHighCard.swift
//  Salmonia3+
//
//  Created by devonly on 2022/10/19.
//

import SwiftUI
import SplatNet3

struct GrizzcoHighCard: View {
    @State private var isPresented: Bool = false
    let maximum: Grizzco.HighData
    let gradePoint: [LineChartEntry]

    var body: some View {
        if #available(iOS 16.0, *) {
            Button(action: {
                isPresented.toggle()
            }, label: {
                GrizzcoHighCardWrapper(maximum: maximum)
            })
            .fullScreen(isPresented: $isPresented, transitionStyle: .flipHorizontal, backgroundColor: .clear, content: {
                LineChartView(chartData: gradePoint)
                    .preferredColorScheme(.dark)
                    .onTapGesture(perform: {
                        isPresented.toggle()
                    })
            })
        } else {
            GrizzcoHighCardWrapper(maximum: maximum)
        }
    }
}

/// イカリング3形式の最高値表示カード
private struct GrizzcoHighCardWrapper: View {
    let maximum: Grizzco.HighData
    
    var body: some View {
        ZStack(alignment: .center, content: {
            Color.black.opacity(0.7)
            VStack(alignment: .leading, spacing: 0, content: {
                HStack(alignment: .center, spacing: 0, content: {
                    if let maxGradePoint = maximum.maxGradePoint, let maxGrade = maximum.maxGrade {
                        Text(maxGrade.localizedText)
                        Text(String(format: " %d", maxGradePoint))
                    }
                    Spacer()
                })
                .padding(.vertical, 5)
                ZStack(alignment: .leading, content: {
                    GeometryReader(content: { geometry in
                        RoundedRectangle(cornerRadius: 5)
                            .fill(Color.white.opacity(0.3))
                        if let maxGradePoint = maximum.maxGradePoint, let maxGrade = maximum.maxGrade {
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
                Text(String(format: " %.2f", maximum.averageWaveCleared))
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
