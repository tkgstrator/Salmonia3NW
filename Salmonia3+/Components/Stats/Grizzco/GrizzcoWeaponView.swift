//
//  GrizzcoSPCard.swift
//  Salmonia3+
//
//  Created by tkgstrator on 2022/10/21.
//

import SwiftUI
import SplatNet3

struct GrizzcoWeaponView: View {
    @ObservedObject var data: Grizzco.Chart.Weapons

    var body: some View {
        switch data.isRandom {
            case true:
                NavigationLink(destination: {
                    RandomWeaponView(data: data.entries)
                }, label: {
                    GrizzcoRandomWeaponContent(data: data)
                })
            case false:
                GrizzcoWeaponContent(data: data)
        }
    }
}

private struct GrizzcoRandomWeaponContent: View {
    @ObservedObject var data: Grizzco.Chart.Weapons
    typealias Entry = Grizzco.Chart.Weapons.Entry

    var body: some View {
        ZStack(alignment: .center, content: {
            Color.black.opacity(0.7)
            VStack(alignment: .leading, spacing: 0, content: {
                Text(bundle: .CoopHistory_SupplyWeapon)
                    .font(systemName: .Splatfont, size: 12)
                    .frame(maxWidth: .infinity, height: 12, alignment: .leading)
                VStack(content: {
                    if let suppliedWeaponCount = data.suppliedWeaponCount,
                       let weaponCount = data.weaponCount
                    {
                        if suppliedWeaponCount == weaponCount {
                            Text(bundle: .Catalog_Complete)
                                .frame(maxWidth: .infinity, alignment: .trailing)
                                .font(systemName: .Splatfont2, size: 20)
                        } else {
                            Text(String(format: "%2d/%2d", suppliedWeaponCount, weaponCount))
                                .frame(maxWidth: .infinity, alignment: .trailing)
                                .font(systemName: .Splatfont2, size: 20)
                        }
                    }
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

private struct GrizzcoWeaponContent: View {
    @ObservedObject var data: Grizzco.Chart.Weapons
    typealias Entry = Grizzco.Chart.Weapons.Entry

    var body: some View {
        ZStack(alignment: .center, content: {
            Color.black.opacity(0.7)
            LazyVGrid(columns: Array(repeating: .init(.flexible(), alignment: .top), count: 2), content: {
                ForEach(data.entries.indices, id: \.self) { index in
                    let entry: Entry = data.entries[index]
                    HStack(content: {
                        Image(bundle: entry.id)
                            .resizable()
                            .scaledToFit()
                            .frame(width: 22, height: 22, alignment: .center)
                            .background(RoundedRectangle(cornerRadius: 4).fill(SPColor.SplatNet3.SPSalmonOrangeDarker))
                        Spacer()
                        Text(String(format: "%.2f%%", entry.percent))
                            .lineLimit(1)
                            .foregroundColor(SPColor.SplatNet2.SPWhite)
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
