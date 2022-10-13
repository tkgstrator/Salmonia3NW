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
                            .font(systemName: .Splatfont2, size: 16)
                    )
                ZStack(alignment: .center, content: {
                    Rectangle()
                        .fill(SPColor.SplatNet2.SPYellow)
                    VStack(alignment: .center, spacing: 6, content: {
                        VStack(alignment: .leading, spacing: nil, content: {
                            Text(bundle: .CoopHistory_JobRatio)
                                .foregroundColor(SPColor.SplatNet2.SPYellow)
                                .font(systemName: .Splatfont2, size: 14)
                                .frame(maxWidth: .infinity, alignment: .leading)
                            HStack(alignment: .top, content: {
                                Text(data.gradeId.localizedText)
                                Text(String(format: "%d", data.gradePointMax))
                                    .font(systemName: .Splatfont2, size: 20)
                                    .frame(maxWidth: .infinity, alignment: .trailing)
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
                                    .font(systemName: .Splatfont2, size: 12)
                                    .foregroundColor(.black)
                                Spacer()
                                Text(String(format: "%.2f", data.clearWaves))
                                    .foregroundColor(.black)
                                    .font(systemName: .Splatfont2, size: 14)
                            })
                            Divider()
                                .frame(height: 2)
                                .background(.black)
                        })
                        Group(content: {
                            HStack(alignment: .top, spacing: nil, content: {
                                Text(bundle: .CoopHistory_Clear)
                                    .foregroundColor(.black)
                                    .font(systemName: .Splatfont2, size: 12)
                                Spacer()
                                Text(String(format: "%d", data.failureWaves.clear))
                                    .font(systemName: .Splatfont2, size: 14)
                                    .foregroundColor(.black)
                            })
                        })
                        Divider()
                            .frame(height: 2)
                            .background(.black)
                        Group(content: {
                            HStack(alignment: .top, spacing: nil, content: {
                                Text(bundle: .CoopHistory_Failure)
                                    .foregroundColor(.black)
                                    .font(systemName: .Splatfont2, size: 12)
                                Spacer()
                                Text(String(format: "%d, %d, %d", data.failureWaves.wave1, data.failureWaves.wave2, data.failureWaves.wave3))
                                    .font(systemName: .Splatfont2, size: 14)
                                    .foregroundColor(.black)
                            })
                        })
                        Spacer()
                    })
                    .padding(.horizontal, 8)
                })
            })
        })
        .clipShape(RoundedRectangle(cornerRadius: 20))
        .shadow(color: .primary, radius: 2, x: 0, y: 0)
    }
}

struct AbstructView_Previews: PreviewProvider {
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
            .previewDevice(PreviewDevice.init(rawValue: device.rawValue))
            .preferredColorScheme(.dark)
        }
    }
}
