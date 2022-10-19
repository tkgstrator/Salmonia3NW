//
//  GrizzcoPointCard.swift
//  Salmonia3+
//
//  Created by devonly on 2022/10/12.
//

import SwiftUI
import SplatNet3

/// イカリング3形式の黄色いポイントカード
struct GrizzcoPointCard: View {
    @ObservedObject var point: Grizzco.PointData

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
                            Text(String(format: "%dp", point.regularPoint))
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
                    Group(content: {
                        HStack(alignment: .bottom, spacing: 0, content: {
                            Text(bundle: .CoopHistory_PlayCount)
                                .font(systemName: .Splatfont2, size: 11)
                                .foregroundColor(Color.black.opacity(0.6))
                                .lineLimit(1)
                                .padding(.trailing, 4)
                                .padding(.bottom, 3)
                                .frame(height: 30, alignment: .top)
                            Spacer()
                            Text(String(format: "%d", point.playCount))
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
                    Group(content: {
                        HStack(alignment: .bottom, spacing: 0, content: {
                            Text(bundle: .CoopHistory_GoldenDeliverCount)
                                .font(systemName: .Splatfont2, size: 11)
                                .foregroundColor(Color.black.opacity(0.6))
                                .lineLimit(1)
                                .padding(.trailing, 4)
                                .padding(.bottom, 3)
                                .frame(height: 30, alignment: .top)
                            Spacer()
                            Text(String(format: "%d", point.goldenIkuraNum))
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
                    Group(content: {
                        HStack(alignment: .bottom, spacing: 0, content: {
                            Text(bundle: .CoopHistory_DeliverCount)
                                .font(systemName: .Splatfont2, size: 11)
                                .foregroundColor(Color.black.opacity(0.6))
                                .lineLimit(1)
                                .padding(.trailing, 4)
                                .padding(.bottom, 3)
                                .frame(height: 30, alignment: .top)
                            Spacer()
                            Text(String(format: "%d", point.ikuraNum))
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
                    Group(content: {
                        HStack(alignment: .bottom, spacing: 0, content: {
                            Text(bundle: .CoopHistory_DefeatBossCount)
                                .font(systemName: .Splatfont2, size: 11)
                                .foregroundColor(Color.black.opacity(0.6))
                                .lineLimit(1)
                                .padding(.trailing, 4)
                                .padding(.bottom, 3)
                                .frame(height: 30, alignment: .top)
                            Spacer()
                            Text(String(format: "%d", point.bossKillCount))
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
                    Group(content: {
                        HStack(alignment: .bottom, spacing: 0, content: {
                            Text(bundle: .CoopHistory_RescueCount)
                                .font(systemName: .Splatfont2, size: 11)
                                .foregroundColor(Color.black.opacity(0.6))
                                .lineLimit(1)
                                .padding(.trailing, 4)
                                .padding(.bottom, 3)
                                .frame(height: 30, alignment: .top)
                            Spacer()
                            Text(String(format: "%d", point.rescueCount))
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
                    Group(content: {
                        HStack(alignment: .bottom, spacing: 0, content: {
                            Text(bundle: .CoopHistory_TotalPoint)
                                .font(systemName: .Splatfont2, size: 11)
                                .foregroundColor(Color.black.opacity(0.6))
                                .lineLimit(1)
                                .padding(.trailing, 4)
                                .padding(.bottom, 3)
                                .frame(height: 30, alignment: .top)
                            Spacer()
                            Text(String(format: "%d", point.regularPointTotal))
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
                })
                .padding(6)
                .padding(.bottom, 20)
            })
            .cornerRadius(20, corners: [.bottomLeft, .bottomRight])
        })
    }
}

struct GrizzcoPointCardView: View {
    let data: StatsService

    var body: some View {
        ScrollView(content: {
            LazyVGrid(columns: Array(repeating: .init(.flexible(maximum: 300), alignment: .top), count: 1), content: {
//                GrizzcoCard(data: data.grizzcoAverageData)
            })
            LazyVGrid(columns: Array(repeating: .init(.flexible(maximum: 197.5), alignment: .top), count: 2), content: {
                LazyVGrid(columns: [.init(.flexible())], spacing: 10, content: {
//                    GrizzcoDataCard(data: data.grizzcoPointData)
//                    GrizzcoScaleCard(data: data.grizzcoPointData)
                })
                GrizzcoPointCard(point: data.point)
            })
        })
    }
}

struct GrizzcoPointCard_Previews: PreviewProvider {
    static let point: Grizzco.PointData = Grizzco.PointData(
        playCount: 999,
        ikuraNum: 999999,
        goldenIkuraNum: 99999,
        bossKillCount: 999,
        regularPoint: 999999,
        regularPointTotal: nil,
        rescueCount: 9999
    )

    static let maximum: Grizzco.HighData = Grizzco.HighData(
        maxGrade: .Eggsecutive_VP,
        maxGradePoint: 600,
        averageWaveCleared: 2.75
    )

    static let scale: Grizzco.ScaleData = Grizzco.ScaleData(
        gold: 999,
        silver: 999,
        bronze: 999
    )

    static let average: Grizzco.AverageData = Grizzco.AverageData(
        weaponList: Array(WeaponType.allCases.shuffled().prefix(4)),
        rareWeapon: WeaponType.Stringer_Bear_Coop,
        ikuraNum: 9999.9,
        goldenIkuraNum: 999.9,
        helpCount: 99.9,
        deadCount: 99.9
    )

    enum XcodePreviewDevice: String, CaseIterable {
        case iPhone13Pro = "iPhone 13 Pro"
        case iPadPro = "iPad Pro"
    }

    static var previews: some View {
        ScrollView(content: {
            LazyVGrid(columns: Array(repeating: .init(.flexible(maximum: 300), alignment: .top), count: 1), content: {
                GrizzcoCard(average: average)
            })
            LazyVGrid(columns: Array(repeating: .init(.flexible(maximum: 197.5), alignment: .top), count: 2), content: {
                LazyVGrid(columns: [.init(.flexible())], spacing: 10, content: {
                    GrizzcoHighCard(maximum: maximum)
                    GrizzcoScaleCard(scale: scale)
                })
                GrizzcoPointCard(point: point)
            })
        })
    }
}
