//
//  GrizzcoSPCard.swift
//  Salmonia3+
//
//  Created by devonly on 2022/10/21.
//

import SwiftUI
import SplatNet3

struct GrizzcoMainCard: View {
    let weapon: [Grizzco.WeaponData]

    var body: some View {
        ZStack(alignment: .center, content: {
            Color.black.opacity(0.7)
            LazyVGrid(columns: Array(repeating: .init(.flexible(), alignment: .top), count: 2), content: {
                ForEach(weapon.indices, id: \.self) { index in
                    let weaponData: Grizzco.WeaponData = weapon[index]
                    HStack(content: {
                        Image(bundle:weaponData.weaponId)
                            .resizable()
                            .scaledToFit()
                            .frame(width: 22, height: 22, alignment: .center)
                            .background(RoundedRectangle(cornerRadius: 4).fill(weaponData.color))
                        Spacer()
                        Text(String(format: "%.2f%%", weaponData.percent))
                            .lineLimit(1)
                            .foregroundColor(weaponData.color)
                            .font(systemName: .Splatfont2, size: 13)
                    })
                }
            })
            .minimumScaleFactor(0.8)
            .padding(8)
        })
        .font(systemName: .Splatfont2, size: 13)
        .cornerRadius(10, corners: .allCorners)
    }
}

struct GrizzcoSPCard_Previews: PreviewProvider {
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

    static let weapon: [Grizzco.WeaponData] = [
        Grizzco.WeaponData(color: SPColor.SplatNet3.SPBlue, weaponId: .Random_Green, count: nil, percent: nil),
        Grizzco.WeaponData(color: SPColor.SplatNet3.SPBlue, weaponId: .Random_Green, count: nil, percent: nil),
        Grizzco.WeaponData(color: SPColor.SplatNet3.SPBlue, weaponId: .Random_Green, count: nil, percent: nil),
        Grizzco.WeaponData(color: SPColor.SplatNet3.SPBlue, weaponId: .Random_Green, count: nil, percent: nil)
    ]

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
                    GrizzcoMainCard(weapon: weapon)
                })
                GrizzcoPointCard(point: point)
            })
        })
    }
}
