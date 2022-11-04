//
//  ResultSpecial.swift
//  Salmonia3+
//
//  Created by tkgstrator on 2022/09/17.
//

import SwiftUI
import SplatNet3

struct ResultSpecial: View {
    @Environment(\.resultStyle) var resultStyle
    let specialUsage: [SpecialType]

    init(result: RealmCoopWave) {
        self.specialUsage = result.specialUsage
    }

    init() {
        self.specialUsage = [
            SpecialType.SpChariot,
            SpecialType.SpChariot,
            SpecialType.SpJetpack,
            SpecialType.SpMicroLaser,
            SpecialType.SpMicroLaser,
        ]
    }

    var body: some View {
        let size: CGFloat = resultStyle == .SPLATNET2 ? 22 : 18
        let borderRadius: CGFloat = resultStyle == .SPLATNET2 ? 11 : 4.7988
        LazyVGrid(columns: Array(repeating: .init(.fixed(size), spacing: 3), count: 4),
                  alignment: .center,
                  spacing: 3,
                  content: {
            ForEach(specialUsage.indices, id: \.self) { index in
                let specialType: SpecialType = specialUsage[index]
                Image(bundle: specialType)
                    .resizable()
                    .scaledToFit()
                    .background(RoundedRectangle(cornerRadius: borderRadius).fill(Color.black))
            }
        })
    }
}

struct ResultSpecial_Previews: PreviewProvider {
    static var previews: some View {
        ResultSpecial()
            .previewLayout(.fixed(width: 124, height: 70))
            .preferredColorScheme(.dark)
    }
}
