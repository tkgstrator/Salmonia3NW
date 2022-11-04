//
//  ResultEgg.swift
//  Salmonia3
//
//  Created by tkgstrator on 2021/12/30.
//  Copyright © 2022 Magi Corporation. All rights reserved.
//

import SwiftUI
import SplatNet3

struct ResultEgg: View {
    let result: RealmCoopResult

    var body: some View {
        LazyVGrid(columns: Array(repeating: .init(.fixed(78.5)), count: 2), content: {
            HStack(alignment: .center, spacing: 0, content: {
                Image(bundle: .Golden)
                    .resizable()
                    .scaledToFit()
                    .frame(width: 18, height: 18, alignment: .center)
                Spacer()
                Text(String(format: "x%d", result.goldenIkuraNum))
                    .foregroundColor(SPColor.SplatNet2.SPWhite)
            })
            .padding(.horizontal, 6)
            .frame(width: 78.5, height: 24, alignment: .leading)
            .background(RoundedRectangle(cornerRadius: 12).fill(SPColor.SplatNet2.SPBackground))
            HStack(alignment: .center, spacing: 0, content: {
                Image(bundle: .Ikura)
                    .resizable()
                    .scaledToFit()
                    .frame(width: 18, height: 18, alignment: .center)
                Spacer()
                Text(String(format: "x%d", result.ikuraNum))
                    .foregroundColor(SPColor.SplatNet2.SPWhite)
            })
            .padding(.horizontal, 6)
            .frame(width: 78.5, height: 24, alignment: .leading)
            .background(RoundedRectangle(cornerRadius: 12).fill(SPColor.SplatNet2.SPBackground))
        })
        .font(systemName: .Splatfont2, size: 13)
    }
}

struct ResultEgg_Previews: PreviewProvider {
    static let result: RealmCoopResult = RealmCoopResult(dummy: true)
    static var previews: some View {
        ResultEgg(result: result)
            .previewLayout(.fixed(width: 200, height: 47))
    }
}
