//
//  GrizzcoAverageCard.swift
//  Salmonia3+
//
//  Created by devonly on 2022/10/19.
//

import SwiftUI
import SplatNet3

struct GrizzcoCard: View {
    let average: Grizzco.AverageData

    var body: some View {
        ZStack(alignment: .center, content: {
            SPColor.SplatNet2.SPRed
            VStack(alignment: .center, spacing: 0, content: {
                GrizzcoScheduleView(average: average)
                Spacer()
                GrizzcoAverageView(average: average)
            })
            .padding(.top, 27)
            .padding(.bottom, 15)
        })
        .frame(width: 300, height: 160, alignment: .center)
        .mask(Image(bundle: .Card))
        .clipShape(RoundedRectangle(cornerRadius: 20))
    }
}

private struct GrizzcoScheduleView: View {
    let average: Grizzco.AverageData

    var body: some View {
        VStack(alignment: .center, spacing: 0, content: {
            Text(bundle: .StageSchedule_SuppliedWeapons)
                .font(systemName: .Splatfont2, size: 13)
                .foregroundColor(Color.white)
                .shadow(color: Color.black, radius: 0, x: 1, y: 1)
                .padding(.bottom, 8)
            let count: Int = average.rareWeapon == nil ? 4 : 5
            LazyVGrid(columns: Array(repeating: .init(.flexible(maximum: 36)), count: count), content: {
                ForEach(average.weaponList.indices, id: \.self) { index in
                    let weaponId: WeaponType = average.weaponList[index]
                    Image(bundle: weaponId)
                        .resizable()
                        .scaledToFit()
                        .frame(width: 36, height: 36, alignment: .center)
                }
                if let rareWeapon = average.rareWeapon {
                    Image(bundle: rareWeapon)
                        .resizable()
                        .scaledToFit()
                        .frame(width: 36, height: 36, alignment: .center)
                }
            })
        })
    }
}

private struct GrizzcoAverageView: View {
    let average: Grizzco.AverageData

    var body: some View {
        VStack(alignment: .leading, spacing: 0, content: {
            Text(bundle: .FesRecord_Average)
                .font(systemName: .Splatfont2, size: 11)
                .foregroundColor(Color.white)
                .shadow(color: Color.black, radius: 0, x: 1, y: 1)
                .padding(.leading, 8)
                .padding(.bottom, 4)
            ZStack(alignment: .center, content: {
                RoundedRectangle(cornerRadius: 15)
                    .fill(Color.black.opacity(0.5))
                HStack(alignment: .center, spacing: 0, content: {
                    Group(content: {
                        Image(bundle: .GoldenIkura)
                            .resizable()
                            .scaledToFit()
                            .frame(width: 18, height: 18, alignment: .center)
                            .frame(maxWidth: 24)
                        Text(String(format: "x%.1f", average.goldenIkuraNum))
                            .shadow(color: Color.black, radius: 0, x: 1, y: 1)
                    })
                    Spacer()
                    Group(content: {
                        Image(bundle: RescueType.Inkling)
                            .resizable()
                            .scaledToFit()
                            .frame(width: 41.75, height: 16, alignment: .center)
                            .frame(maxWidth: 41.75)
                        Text(String(format: "x%.1f", average.helpCount))
                            .shadow(color: Color.black, radius: 0, x: 1, y: 1)
                    })
                    Spacer()
                    Group(content: {
                        Image(bundle: DeathType.Inkling)
                            .resizable()
                            .scaledToFit()
                            .frame(width: 41.75, height: 16, alignment: .center)
                            .frame(maxWidth: 41.75)
                        Text(String(format: "x%.1f", average.deadCount))
                            .shadow(color: Color.black, radius: 0, x: 1, y: 1)
                    })
                })
                .font(systemName: .Splatfont2, size: 15)
                .padding(.horizontal, 16)
            })
            .foregroundColor(SPColor.SplatNet2.SPWhite)
            .frame(width: 270, height: 30, alignment: .center)
        })
    }
}

struct GrizzcoAverageCard_Previews: PreviewProvider {
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
