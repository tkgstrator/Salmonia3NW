//
//  ResultDefeated.swift
//  Salmonia3
//
//  Created by devonly on 2021/12/30.
//  Copyright © 2022 Magi Corporation. All rights reserved.
//

import SwiftUI
import RealmSwift
import SplatNet3

struct ResultDefeated: View {
    let bossKillCountsTotal: Int

    init(bossKillCountsTotal: Int) {
        self.bossKillCountsTotal = bossKillCountsTotal
    }

    var body: some View {
        GeometryReader(content: { geometry in
            let scale: CGFloat = geometry.width / 172
            Text("BOSS_SALMONIDS_DEFEATED_\(bossKillCountsTotal)")
                .font(systemName: .Splatfont2, size: 11 * scale)
                .foregroundColor(SPColor.Theme.SPYellow)
                .shadow(color: .black, radius: 0 * scale, x: 1 * scale, y: 1 * scale)
                .position(geometry.center)
        })
        .aspectRatio(172/12.5, contentMode: .fit)
    }
}

struct ResultDefeated_Previews: PreviewProvider {
    static var previews: some View {
        ResultDefeated(bossKillCountsTotal: 99)
            .previewLayout(.fixed(width: 344, height: 25))
            .preferredColorScheme(.dark)
    }
}
