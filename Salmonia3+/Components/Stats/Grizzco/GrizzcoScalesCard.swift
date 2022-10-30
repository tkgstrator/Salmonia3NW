//
//  GrizzcoScalesCard.swift
//  Salmonia3+
//
//  Created by devonly on 2022/10/19.
//

import SwiftUI
import SplatNet3

struct GrizzcoScaleCard: View {
    @ObservedObject var scale: Grizzco.ScaleData

    var body: some View {
        ZStack(alignment: .center, content: {
            Color.black.opacity(0.7)
            VStack(alignment: .leading, spacing: 0, content: {
                Text(bundle: .CoopHistory_Scale)
                    .font(systemName: .Splatfont, size: 12)
                    .frame(maxWidth: .infinity, height: 12, alignment: .leading)
                LazyVGrid(columns: Array(repeating: .init(.fixed(34)), count: 3), content: {
                    VStack(alignment: .center, spacing: 0, content: {
                        Image(bundle: ScaleType.Bronze)
                            .resizable()
                            .scaledToFit()
                            .frame(width: 25, height: 25, alignment: .center)
                        Text(String(format: "x%d", scale.bronze))
                            .padding(.top, 2)
                    })
                    VStack(alignment: .center, spacing: 0, content: {
                        Image(bundle: ScaleType.Silver)
                            .resizable()
                            .scaledToFit()
                            .frame(width: 25, height: 25, alignment: .center)
                        Text(String(format: "x%d", scale.silver))
                            .padding(.top, 2)
                    })
                    VStack(alignment: .center, spacing: 0, content: {
                        Image(bundle: ScaleType.Gold)
                            .resizable()
                            .scaledToFit()
                            .frame(width: 25, height: 25, alignment: .center)
                        Text(String(format: "x%d", scale.gold))
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

struct GrizzcoScales_Previews: PreviewProvider {
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
//                    GrizzcoHighCard(maximum: maximum)
                    GrizzcoScaleCard(scale: scale)
                })
                GrizzcoPointCard(point: point)
            })
        })
    }
}
