//
//  ScaleChartView.swift
//  Salmonia3+
//
//  Created by devonly on 2022/10/12.
//

import SwiftUI
import SwiftUICharts
import SplatNet3

class ScaleData: ObservableObject {
    @Published var gold: Int
    @Published var silver: Int
    @Published var bronze: Int

    init(gold: Int, silver: Int, bronze: Int) {
        self.gold = gold
        self.silver = silver
        self.bronze = bronze
    }
}

struct ScaleChartView: View {
    @Environment(\.colorScheme) var colorScheme
    @ObservedObject var data: ScaleData

    var body: some View {
        ZStack(alignment: .center, content: {
            VStack(alignment: .center, spacing: 0, content: {
                Rectangle()
                    .fill(Color.black)
                    .aspectRatio(120/22, contentMode: .fit)
                    .overlay(
                        Text(bundle: .CoopHistory_Scale)
                            .foregroundColor(SPColor.SplatNet2.SPOrange)
                            .font(systemName: .Splatfont2, size: 14)
                    )
                ZStack(alignment: .center, content: {
                    Rectangle()
                        .fill(SPColor.SplatNet2.SPBackground)
                    LazyVGrid(columns: Array(repeating: .init(.flexible(maximum: 60)), count: 3), content: {
                        VStack(alignment: .center, spacing: 0, content: {
                            Image(bundle: .Bronze)
                                .resizable()
                                .scaledToFit()
                                .frame(width: 30, height: 30, alignment: .center)
                            Text(String(format: "x%d", data.bronze))
                                .font(systemName: .Splatfont2, size: 14)
                        })
                        VStack(alignment: .center, spacing: 0, content: {
                            Image(bundle: .Silver)
                                .resizable()
                                .scaledToFit()
                                .frame(width: 30, height: 30, alignment: .center)
                            Text(String(format: "x%d", data.silver))
                                .font(systemName: .Splatfont2, size: 14)
                        })
                        VStack(alignment: .center, spacing: 0, content: {
                            Image(bundle: .Gold)
                                .resizable()
                                .scaledToFit()
                                .frame(width: 30, height: 30, alignment: .center)
                            Text(String(format: "x%d", data.gold))
                                .font(systemName: .Splatfont2, size: 14)
                        })
                    })
                    .foregroundColor(.white)
                    .padding([.bottom, .top])
                })
            })
        })
        .clipShape(RoundedRectangle(cornerRadius: 20))
        .shadow(color: .primary, radius: 2, x: 0, y: 0)
        .aspectRatio(120/50, contentMode: .fit)
    }
}

struct ScaleChartView_Previews: PreviewProvider {
    static let data: GrizzcoPointData = GrizzcoPointData(
        playCount: 999,
        maxGrade: GradeType.Eggsecutive_VP,
        maxGradePoint: 999,
        failureWaves: (clear: 999, wave1: 10, wave2: 10, wave3: 10),
        regularPoint: 99999,
        goldenIkuraNum: 99999,
        ikuraNum: 999999,
        bossDefeatedCount: 9999,
        bossCount: 99,
        rescueCount: 999,
        totalPoint: 999,
        scales: (bronze: 999, silver: 999, gold: 999)
    )

    static let record: AbstructData = AbstructData(
        gradeId: .Eggsecutive_VP,
        gradePointMax: 999,
        failureWaves: (clear: 999, wave1: 9, wave2: 9, wave3: 99)
    )

    static let scale: ScaleData = ScaleData(gold: 100, silver: 100, bronze: 100)

    static var previews: some View {
        LazyVGrid(columns: Array(repeating: .init(.flexible(maximum: 240), alignment: .top), count: 2), content: {
            LazyVStack(alignment: .center, spacing: nil, content: {
                AbstructView(data: record)
                ScaleChartView(data: scale)
            })
            GrizzcoPointCard(data: data)
        })
        .previewLayout(.fixed(width: 600, height: 800))
        .preferredColorScheme(.dark)
    }
}
