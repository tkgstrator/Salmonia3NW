//
//  AbstructView.swift
//  Salmonia3+
//
//  Created by devonly on 2022/10/12.
//

import SwiftUI
import SplatNet3

class AbstructData: ObservableObject {
    /// ポイント
    @Published var gradePointMax: Int
    /// 遊んだ回数
    @Published var gradeId: GradeType
    /// 平均クリアWAVE
    @Published var clearWaves: Double
    /// WAVE
    @Published var failureWaves: (clear: Int, wave1: Int, wave2: Int, wave3: Int)

    public init(
        gradeId: GradeType,
        gradePointMax: Int,
        failureWaves: (clear: Int, wave1: Int, wave2: Int, wave3: Int)
    ) {
        self.gradeId = gradeId
        self.gradePointMax = gradePointMax
        self.failureWaves = failureWaves
        self.clearWaves = {
            let total: Int = failureWaves.wave1 + failureWaves.wave2 + failureWaves.wave3 + failureWaves.clear
            if total == .zero {
                return .zero
            }
            return Double(failureWaves.clear * 3 + failureWaves.wave3 * 2 + failureWaves.wave2) / Double(total)
        }()
    }
}

struct AbstructView: View {
    @ObservedObject var data: AbstructData

    var body: some View {
        ZStack(alignment: .center, content: {
            VStack(alignment: .center, spacing: 0, content: {
                Rectangle()
                    .fill(Color.black)
                    .aspectRatio(120/22, contentMode: .fit)
                    .overlay(
                        Text(bundle: .CoopHistory_HighestScore)
                            .foregroundColor(SPColor.SplatNet2.SPOrange)
                            .font(systemName: .Splatfont2, size: 14)
                    )
                ZStack(alignment: .center, content: {
                    Rectangle()
                        .fill(SPColor.SplatNet2.SPYellow)
                    VStack(alignment: .center, spacing: 6, content: {
                        VStack(alignment: .leading, spacing: nil, content: {
                            Text(bundle: .CoopHistory_JobRatio)
                                .foregroundColor(SPColor.SplatNet2.SPYellow)
                                .frame(maxWidth: .infinity, alignment: .leading)
                            HStack(alignment: .top, content: {
                                Text(data.gradeId.localizedText)
                                Spacer()
                                Text(String(format: "%d", data.gradePointMax))
                            })
                            .font(systemName: .Splatfont2, size: 16)
                            .foregroundColor(SPColor.SplatNet2.SPYellow)
                        })
                        .padding(8)
                        .background(RoundedRectangle(cornerRadius: 14).fill(SPColor.SplatNet2.SPBackground))
                        .padding(.top, 8)
                        Group(content: {
                            HStack(alignment: .top, spacing: nil, content: {
                                Text(bundle: .CoopHistory_AverageClearWaves)
                                    .lineLimit(1)
                                Spacer()
                                Text(String(format: "%.2f", data.clearWaves))
                            })
                            Divider()
                                .frame(height: 2)
                                .background(.gray)
                        })
                        Group(content: {
                            HStack(alignment: .top, spacing: nil, content: {
                                Text(bundle: .CoopHistory_Clear)
                                    .font(systemName: .Splatfont2, size: 12)
                                Spacer()
                                Text(String(format: "%d", data.failureWaves.clear))
                            })
                            Divider()
                                .frame(height: 2)
                                .background(.gray)
                        })
                        Group(content: {
                            HStack(alignment: .top, spacing: nil, content: {
                                Text(bundle: .CoopHistory_Failure)
                                Spacer()
                                Text(String(format: "%d, %d, %d", data.failureWaves.wave1, data.failureWaves.wave2, data.failureWaves.wave3))
                            })
                        })
                        Spacer()
                    })
                    .padding(.horizontal, 8)
                })
                .font(systemName: .Splatfont2, size: 13)
                .foregroundColor(.black)
            })
        })
        .clipShape(RoundedRectangle(cornerRadius: 20))
        .shadow(color: .primary, radius: 2, x: 0, y: 0)
    }
}

struct AbstructView_Previews: PreviewProvider {
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
            LazyVGrid(columns: Array(repeating: .init(.flexible(maximum: 220), alignment: .top), count: 2), content: {
                LazyVStack(alignment: .center, spacing: nil, content: {
                    AbstructView(data: record)
                    ScaleChartView(data: scale)
                })
                GrizzcoPointCard(data: data)
            })
            .padding([.horizontal])
            .previewDevice(PreviewDevice.init(rawValue: device.rawValue))
            .preferredColorScheme(.dark)
        }
    }
}
