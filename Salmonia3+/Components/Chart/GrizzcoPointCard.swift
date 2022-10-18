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
    /// ポイントカードのデータ
    @Published var values: [(Int, LocalizedText)]
    /// ウロコのデータ
    @Published var scales: (bronze: Int, silver: Int, gold: Int)
    /// WAVEの情報
    @Published var failureWaves: (clear: Int, wave1: Int, wave2: Int, wave3: Int)
    /// オカシラシャケ
    @Published var boss: (count: Int, killCount: Int)
    /// 最高評価
    @Published var maxGrade: GradeType
    /// 最高評価レート
    @Published var maxGradePoint: Int
    /// 平均クリアWAVE
    @Published var averageWavesCleared: Double

    public init(
        playCount: Int,
        maxGrade: GradeType,
        maxGradePoint: Int,
        failureWaves: (clear: Int, wave1: Int, wave2: Int, wave3: Int),
        regularPoint: Int,
        goldenIkuraNum: Int,
        ikuraNum: Int,
        bossDefeatedCount: Int,
        bossCount: Int,
        rescueCount: Int,
        totalPoint: Int,
        scales: (bronze: Int, silver: Int, gold: Int)
    ) {
        self.regularPoint = regularPoint
        self.values = [
            (playCount, .CoopHistory_PlayCount),
            (goldenIkuraNum, .CoopHistory_GoldenDeliverCount),
            (ikuraNum, .CoopHistory_DeliverCount),
            (bossDefeatedCount, .CoopHistory_DefeatBossCount),
            (rescueCount, .CoopHistory_RescueCount),
            (totalPoint, .CoopHistory_TotalPoint)
        ]
        self.scales = scales
        self.boss = (count: bossCount, killCount: bossDefeatedCount)
        self.maxGrade = maxGrade
        self.maxGradePoint = maxGradePoint
        self.failureWaves = failureWaves
        self.averageWavesCleared = Double(failureWaves.clear * 3 + failureWaves.wave3 * 2 + failureWaves.wave1 * 1) / Double(playCount)
    }
}

struct GrizzcoScaleCard: View {
    @ObservedObject var data: GrizzcoPointData

    var body: some View {
        ZStack(alignment: .center, content: {
            Color.black.opacity(0.7)
            VStack(alignment: .leading, spacing: 0, content: {
                Text(bundle: .CoopHistory_Scale)
                    .font(systemName: .Splatfont, size: 12)
                    .frame(maxWidth: .infinity, height: 20, alignment: .leading)
                LazyVGrid(columns: Array(repeating: .init(.fixed(40)), count: 3), content: {
                    VStack(alignment: .center, spacing: 0, content: {
                        Image(bundle: ScaleType.Bronze)
                            .resizable()
                            .scaledToFit()
                            .frame(width: 25, height: 25, alignment: .center)
                        Text(String(format: "x%d", data.scales.bronze))
                            .padding(.top, 2)
                    })
                    VStack(alignment: .center, spacing: 0, content: {
                        Image(bundle: ScaleType.Silver)
                            .resizable()
                            .scaledToFit()
                            .frame(width: 25, height: 25, alignment: .center)
                        Text(String(format: "x%d", data.scales.silver))
                            .padding(.top, 2)
                    })
                    VStack(alignment: .center, spacing: 0, content: {
                        Image(bundle: ScaleType.Gold)
                            .resizable()
                            .scaledToFit()
                            .frame(width: 25, height: 25, alignment: .center)
                        Text(String(format: "x%d", data.scales.gold))
                            .padding(.top, 2)
                    })
                })
                .padding(.top, 8)
                .padding(.bottom, 2)
            })
            .padding(.vertical, 6)
            .padding(.horizontal, 10)
        })
        .foregroundColor(SPColor.SplatNet3.SPSalmonGreen)
        .font(systemName: .Splatfont2, size: 12)
        .cornerRadius(10, corners: .allCorners)
    }
}

struct GrizzcoDataCard: View {
    @ObservedObject var data: GrizzcoPointData

    var body: some View {
        ZStack(alignment: .center, content: {
            Color.black.opacity(0.7)
            VStack(alignment: .leading, spacing: 0, content: {
                HStack(alignment: .center, spacing: 0, content: {
                    Text(data.maxGrade.localizedText)
                    Text(String(format: " %d", data.maxGradePoint))
                    Spacer()
                })
                .padding(.vertical, 5)
                ZStack(alignment: .leading, content: {
                    GeometryReader(content: { geometry in
                        RoundedRectangle(cornerRadius: 5)
                            .fill(Color.white.opacity(0.3))
                        Rectangle()
                            .fill(SPColor.SplatNet3.SPCoop)
                            .frame(width: geometry.width * (Double(data.maxGradePoint) / Double(data.maxGrade == GradeType.Eggsecutive_VP ? 999 : 100)))
                    })
                })
                .clipShape(RoundedRectangle(cornerRadius: 5))
                .frame(height: 10)
                .padding(.bottom, 15)
                Text(bundle: .CoopHistory_AverageClearWaves)
                Text(String(format: " %.2f", data.averageWavesCleared))
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

struct GrizzcoPointCard: View {
    @ObservedObject var data: GrizzcoPointData

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
                            Text(String(format: "%dp", data.regularPoint))
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
                    ForEach(data.values, id: \.1.rawValue) { value in
                        HStack(alignment: .bottom, spacing: 0, content: {
                            Text(bundle: value.1)
                                .font(systemName: .Splatfont2, size: 11)
                                .foregroundColor(Color.black.opacity(0.6))
                                .lineLimit(1)
                                .padding(.trailing, 4)
                                .padding(.bottom, 3)
                                .frame(maxHeight: 30, alignment: .top)
                            Spacer()
                            Text(String(format: "%d", value.0))
                                .font(systemName: .Splatfont2, size: 13)
                                .foregroundColor(Color.black)
                                .frame(maxHeight: 30, alignment: .bottom)
                        })
                        .padding(.horizontal, 3)
                        .frame(height: 30)
                        if value.1 != .CoopHistory_TotalPoint {
                            DashedLine()
                                .stroke(style: StrokeStyle(lineWidth: 2, dash: [4]))
                                .foregroundColor(Color.black.opacity(0.3))
                                .frame(height: 2)
                        }
                    }
                })
                .padding(6)
                .padding(.bottom, 20)
            })
            .cornerRadius(20, corners: [.bottomLeft, .bottomRight])
        })
    }
}

extension View {
    func frame(maxWidth: CGFloat, height: CGFloat, alignment: Alignment) -> some View{
        self.frame(maxWidth: maxWidth, alignment: alignment).frame(height: height)
    }
}

struct GrizzcoPointCardView: View {
    let data: GrizzcoPointData

    var body: some View {
        LazyVGrid(columns: Array(repeating: .init(.flexible(maximum: 197.5), alignment: .top), count: 2), content: {
            LazyVGrid(columns: [.init(.flexible())], spacing: 10, content: {
                GrizzcoDataCard(data: data)
                GrizzcoScaleCard(data: data)
            })
            GrizzcoPointCard(data: data)
        })
    }
}

struct GrizzcoPointCard_Previews: PreviewProvider {
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
        failureWaves: (clear: 999, wave1: 99, wave2: 99, wave3: 99)
    )
    static let scale: ScaleData = ScaleData(gold: 100, silver: 100, bronze: 100)

    enum XcodePreviewDevice: String, CaseIterable {
        case iPhone13Pro = "iPhone 13 Pro"
        case iPadPro = "iPad Pro"
    }

    static var previews: some View {
        ForEach(XcodePreviewDevice.allCases, id:\.rawValue) { device in
            ScrollView(content: {
                LazyVGrid(columns: Array(repeating: .init(.flexible(maximum: 197.5), alignment: .top), count: 2), content: {
                    LazyVGrid(columns: [.init(.flexible())], spacing: 10, content: {
                        GrizzcoDataCard(data: data)
                        GrizzcoScaleCard(data: data)
                    })
                    GrizzcoPointCard(data: data)
                })

            })
            .padding([.horizontal])
            .previewDevice(PreviewDevice.init(rawValue: device.rawValue))
//            .preferredColorScheme(.dark)
        }
    }
}
