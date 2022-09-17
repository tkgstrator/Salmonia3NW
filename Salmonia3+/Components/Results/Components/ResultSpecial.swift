//
//  ResultSpecial.swift
//  Salmonia3+
//
//  Created by devonly on 2022/09/17.
//

import SwiftUI
import SplatNet3

struct ResultSpecial: View {
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
        LazyVGrid(columns: Array(repeating: .init(.flexible(maximum: 30), spacing: 2), count: 4), alignment: .center, spacing: 3, content: {
            ForEach(specialUsage.indices, id: \.self) { index in
                let specialType: SpecialType = specialUsage[index]
                Image(bundle: specialType)
                    .resizable()
                    .scaledToFit()
                    .padding(2)
                    .background(RoundedRectangle(cornerRadius: 8).fill(Color.primary.opacity(0.7)))
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
