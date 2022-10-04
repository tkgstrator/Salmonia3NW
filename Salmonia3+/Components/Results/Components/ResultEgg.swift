//
//  ResultEgg.swift
//  Salmonia3
//
//  Created by devonly on 2021/12/30.
//  Copyright © 2022 Magi Corporation. All rights reserved.
//

import SwiftUI
import SplatNet3

struct ResultEgg: View {
    let ikuraNum: Int
    let goldenIkuraNum: Int
    let goldenIkuraAssistNum: Int

    var body: some View {
        GeometryReader(content: { geometry in
            let scale: CGFloat = geometry.width / 160
            HStack(spacing: 3 * scale, content: {
                HStack(spacing: 0, content: {
                    Image(bundle: .Golden)
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                        .frame(width: 18 * scale)
                    Spacer()
                    HStack(alignment: .firstTextBaseline, spacing: 0, content: {
                        Text(String(format: "x%2d", goldenIkuraNum))
                            .foregroundColor(SPColor.SplatNet2.SPWhite)
                    })
                })
                .padding(.horizontal, 6 * scale)
                .frame(height: 24 * scale)
                .background(Capsule().fill(Color.black.opacity(0.75)))
                HStack(spacing: 0, content: {
                    Image(bundle: .Power)
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                        .frame(width: 18 * scale)
                    Spacer()
                    Text(String(format: "x%4d", ikuraNum))
                        .foregroundColor(SPColor.SplatNet2.SPWhite)
                })
                .padding(.horizontal, 6 * scale)
                .frame(height: 24 * scale)
                .background(Capsule().fill(Color.black.opacity(0.75)))
            })
            .font(systemName: .Splatfont2, size: 14 * scale)
        })
        .aspectRatio(160/24, contentMode: .fit)
    }
}

struct ResultEgg_Previews: PreviewProvider {
    static var previews: some View {
        ResultEgg(ikuraNum: 9999, goldenIkuraNum: 999, goldenIkuraAssistNum: 99)
            .previewLayout(.fixed(width: 320, height: 47))
        ResultEgg(ikuraNum: 9999, goldenIkuraNum: 999, goldenIkuraAssistNum: 99)
            .previewLayout(.fixed(width: 160, height: 23.5))
    }
}
