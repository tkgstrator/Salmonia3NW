//
//  GrizzcoPointCard.swift
//  Salmonia3+
//
//  Created by devonly on 2022/10/12.
//

import SwiftUI
import SplatNet3

class GrizzcoPointData: ObservableObject {
    /// ポイント
    @Published var regularPoint: Int
    /// 遊んだ回数
    @Published var playCount: Int
    /// ポイントカードのデータ
    @Published var values: [(Int, LocalizedText)]

    public init(
        playCount: Int,
        regularPoint: Int,
        goldenIkuraNum: Int,
        ikuraNum: Int,
        bossDefeatedCount: Int,
        rescueCount: Int,
        totalPoint: Int
    ) {
        self.regularPoint = regularPoint
        self.playCount = playCount
        self.values = [
            (goldenIkuraNum, .CoopHistory_GoldenDeliverCount),
            (ikuraNum, .CoopHistory_DeliverCount),
            (bossDefeatedCount, .CoopHistory_DefeatBossCount),
            (rescueCount, .CoopHistory_RescueCount),
            (totalPoint, .CoopHistory_TotalPoint)
        ]
    }
}

struct GrizzcoPointCard: View {
    @ObservedObject var data: GrizzcoPointData

    var body: some View {
        ZStack(alignment: .center, content: {
            VStack(alignment: .center, spacing: 0, content: {
                Rectangle()
                    .fill(Color.black)
                    .aspectRatio(120/22, contentMode: .fit)
                    .overlay(
                        Text(bundle: .CoopHistory_KumaPointCard)
                            .foregroundColor(SPColor.SplatNet2.SPOrange)
                            .font(systemName: .Splatfont2, size: 16)
                    )
                ZStack(alignment: .center, content: {
                    Rectangle()
                        .fill(SPColor.SplatNet2.SPYellow)
                    VStack(alignment: .center, spacing: 8, content: {
                        RoundedRectangle(cornerRadius: 14)
                            .foregroundColor(SPColor.SplatNet2.SPBackground)
                            .aspectRatio(120/40, contentMode: .fit)
                            .padding(.top, 8)
                            .overlay(
                                VStack(alignment: .leading, spacing: nil, content: {
                                    Text(bundle: .CoopHistory_RegularPoint)
                                        .foregroundColor(SPColor.SplatNet2.SPYellow)
                                        .font(systemName: .Splatfont2, size: 14)
                                        .frame(maxWidth: .infinity, alignment: .leading)
                                    Text(String(format: "%dp", data.regularPoint))
                                        .foregroundColor(SPColor.SplatNet2.SPYellow)
                                        .font(systemName: .Splatfont2, size: 20)
                                        .frame(maxWidth: .infinity, alignment: .trailing)
                                })
                                .padding(.horizontal, 8)
                                .padding(.top)
                            )
                        Group(content: {
                            HStack(alignment: .top, spacing: nil, content: {
                                Text(bundle: .CoopHistory_PlayCount)
                                    .font(systemName: .Splatfont2, size: 14)
                                    .foregroundColor(.black)
                                Spacer()
                                Text(String(format: "%d", data.playCount))
                                    .foregroundColor(.black)
                                    .font(systemName: .Splatfont2, size: 16)
                            })
                            Divider()
                                .frame(height: 2)
                                .background(.black)
                        })
                        ForEach(data.values, id: \.1.rawValue) { value in
                            Group(content: {
                                HStack(alignment: .top, spacing: nil, content: {
                                    Text(bundle: value.1)
                                        .foregroundColor(.black)
                                        .font(systemName: .Splatfont2, size: 14)
                                    Spacer()
                                    Text(String(format: "%d", value.0))
                                        .font(systemName: .Splatfont2, size: 16)
                                        .foregroundColor(.black)
                                })
                                if value.1 != .CoopHistory_TotalPoint {
                                    Divider()
                                        .frame(height: 2)
                                        .background(.black)
                                }
                            })
                        }
                        Spacer()
                    })
                    .padding(.horizontal, 8)
                })
            })
        })
        .clipShape(RoundedRectangle(cornerRadius: 20))
        .shadow(color: .primary, radius: 2, x: 0, y: 0)
        .aspectRatio(120/200, contentMode: .fit)
    }
}

struct GrizzcoPointCard_Previews: PreviewProvider {
    static let data: GrizzcoPointData = GrizzcoPointData(
        playCount: 99999,
        regularPoint: 999999,
        goldenIkuraNum: 9999999,
        ikuraNum: 99999999,
        bossDefeatedCount: 999999,
        rescueCount: 999999,
        totalPoint: 9999999
    )
    static let record: AbstructData = AbstructData(
        gradeId: .Eggsecutive_VP,
        gradePointMax: 999,
        failureWaves: (clear: 999, wave1: 99, wave2: 99, wave3: 99)
    )
    static var previews: some View {
        LazyVGrid(columns: Array(repeating: .init(.flexible(maximum: 240), alignment: .top), count: 2), content: {
            LazyVStack(alignment: .center, spacing: nil, content: {
                AbstructView(data: record)
//                ScaleChartView()
            })
            GrizzcoPointCard(data: data)
        })
        .previewLayout(.fixed(width: 600, height: 800))
        .preferredColorScheme(.dark)
    }
}
