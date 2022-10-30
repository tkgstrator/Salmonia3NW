//
//  GrizzcoSPCard.swift
//  Salmonia3+
//
//  Created by devonly on 2022/10/21.
//

import SwiftUI
import SplatNet3

struct GrizzcoMainCard: View {
    let weapon: [Grizzco.ChartEntry.Weapons]

    var body: some View {
        ZStack(alignment: .center, content: {
            Color.black.opacity(0.7)
            LazyVGrid(columns: Array(repeating: .init(.flexible(), alignment: .top), count: 2), content: {
                ForEach(weapon.indices, id: \.self) { index in
//                    let weaponData: Grizzco.WeaponData = weapon[index]
//                    HStack(content: {
//                        Image(bundle: weaponData.weaponId)
//                            .resizable()
//                            .scaledToFit()
//                            .frame(width: 22, height: 22, alignment: .center)
//                            .background(RoundedRectangle(cornerRadius: 4).fill(weaponData.color))
//                        Spacer()
//                        Text(String(format: "%.2f%%", weaponData.percent))
//                            .lineLimit(1)
//                            .foregroundColor(weaponData.color)
//                            .font(systemName: .Splatfont2, size: 13)
//                    })
                }
            })
            .minimumScaleFactor(0.8)
            .padding(8)
        })
        .font(systemName: .Splatfont2, size: 13)
        .cornerRadius(10, corners: .allCorners)
    }
}
