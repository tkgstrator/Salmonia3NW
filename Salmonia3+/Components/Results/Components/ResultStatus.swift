//
//  ResultStatus.swift
//  Salmonia3
//
//  Created by devonly on 2021/12/30.
//  Copyright © 2022 Magi Corporation. All rights reserved.
//

import SwiftUI
import SplatNet3

struct ResultStatus: View {
    let deadCount: Int
    let helpCount: Int

    var body: some View {
        GeometryReader(content: { geometry in
            let scale: CGFloat = geometry.width / 160
            HStack(spacing: 3, content: {
                HStack(spacing: -10, content: {
                    Image(bundle: ButtonType.Rescue)
                        .resizable()
                        .scaledToFit()
                        .frame(height: 16 * scale)
                    Spacer()
                    Text(String(format: "x%2d", helpCount))
                        .foregroundColor(SPColor.SplatNet2.SPWhite)
                })
                .padding(.horizontal, 6 * scale)
                .frame(height: 24 * scale)
                .background(Capsule().fill(Color.black.opacity(0.75)))
                HStack(spacing: -10, content: {
                    Image(bundle: ButtonType.Death)
                        .resizable()
                        .scaledToFit()
                        .frame(height: 16 * scale)
                    Spacer()
                    Text(String(format: "x%2d", deadCount))
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

struct ResultStatus_Previews: PreviewProvider {
    static var previews: some View {
        ResultStatus(deadCount: 3, helpCount: 3)
            .previewLayout(.fixed(width: 200, height: 30))
    }
}
