//
//  GrizzcoSPCard.swift
//  Salmonia3+
//
//  Created by devonly on 2022/10/21.
//

import SwiftUI
import SplatNet3

struct GrizzcoWeaponView: View {
    @ObservedObject var data: Grizzco.Chart.Weapons

    var body: some View {
        if #available(iOS 16.0, *), false {
            ChartView(destination: {
                EmptyView()
            }, content: {
                GrizzcoWeaponContent(data: data)
            })
        } else {
            GrizzcoWeaponContent(data: data)
        }
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
