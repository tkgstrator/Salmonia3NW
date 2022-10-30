//
//  GrizzcoAverageCard.swift
//  Salmonia3+
//
//  Created by devonly on 2022/10/19.
//

import SwiftUI
import SplatNet3

struct GrizzcoAverageView: View {
    @ObservedObject var data: Grizzco.Chart.Average

    var body: some View {
        ZStack(alignment: .center, content: {
            SPColor.SplatNet2.SPRed
            VStack(alignment: .center, spacing: 0, content: {
                GrizzcoScheduleView(data: data)
                Spacer()
                GrizzcoAverageContent(data: data)
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
    @ObservedObject var data: Grizzco.Chart.Average

    var body: some View {
        VStack(alignment: .center, spacing: 0, content: {
            Text(bundle: .StageSchedule_SuppliedWeapons)
                .font(systemName: .Splatfont2, size: 13)
                .foregroundColor(Color.white)
                .shadow(color: Color.black, radius: 0, x: 1, y: 1)
                .padding(.bottom, 8)
            let count: Int = data.rareWeapon == nil ? 4 : 5
            LazyVGrid(columns: Array(repeating: .init(.flexible(maximum: 36)), count: count), content: {
                ForEach(data.weaponList.indices, id: \.self) { index in
                    let weaponId: WeaponType = data.weaponList[index]
                    Image(bundle: weaponId)
                        .resizable()
                        .scaledToFit()
                        .frame(width: 36, height: 36, alignment: .center)
                }
                if let rareWeapon = data.rareWeapon {
                    Image(bundle: rareWeapon)
                        .resizable()
                        .scaledToFit()
                        .frame(width: 36, height: 36, alignment: .center)
                }
            })
        })
    }
}

private struct GrizzcoAverageContent: View {
    @ObservedObject var data: Grizzco.Chart.Average

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
                        Text(String(format: "x%.1f", data.goldenIkuraNum))
                            .shadow(color: Color.black, radius: 0, x: 1, y: 1)
                    })
                    Spacer()
                    Group(content: {
                        Image(bundle: RescueType.Inkling)
                            .resizable()
                            .scaledToFit()
                            .frame(width: 41.75, height: 16, alignment: .center)
                            .frame(maxWidth: 41.75)
                        Text(String(format: "x%.1f", data.helpCount))
                            .shadow(color: Color.black, radius: 0, x: 1, y: 1)
                    })
                    Spacer()
                    Group(content: {
                        Image(bundle: DeathType.Inkling)
                            .resizable()
                            .scaledToFit()
                            .frame(width: 41.75, height: 16, alignment: .center)
                            .frame(maxWidth: 41.75)
                        Text(String(format: "x%.1f", data.deadCount))
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
