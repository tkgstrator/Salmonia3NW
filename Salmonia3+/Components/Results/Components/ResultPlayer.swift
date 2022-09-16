//
//  ResultPlayer.swift
//  Salmonia3+
//
//  Created by devonly on 2022/09/17.
//

import SwiftUI

struct ResultPlayer: View {
    let result: RealmCoopPlayer
    let foregroundColor = Color(hex: "FF7500")


    var body: some View {
        GeometryReader(content: { geometry in
            let scale: CGFloat = geometry.width / 356
            ZStack(alignment: .bottom, content: {
                Salmon()
                    .fill(foregroundColor)
                HStack(alignment: .bottom, spacing: 0, content: {
                    VStack(alignment: .center, spacing: 0, content: {
                        Text(result.name)
                            .font(systemName: .Splatfont2, size: 17 * scale)
                            .foregroundColor(.white)
                            .shadow(color: .black, radius: 0 * scale, x: 1 * scale, y: 1 * scale)
                            .frame(height: 18 * scale)
                        ResultWeapon(weaponList: result.weaponList, specialWeapon: result.specialId)
                        ResultDefeated(bossKillCountsTotal: result.bossKillCountsTotal)
                    })
                    .padding(.leading, 12 * scale)
                    VStack(alignment: .trailing, spacing: 6 * scale, content: {
                        ResultEgg(ikuraNum: result.ikuraNum, goldenIkuraNum: result.goldenIkuraNum, goldenIkuraAssistNum: result.goldenIkuraAssistNum)
                        ResultStatus(deadCount: result.deadCount, helpCount: result.helpCount)
                    })
                    .padding(.trailing, 16 * scale)
                    .frame(width: 160 * scale, height: 51 * scale)
                })
                .padding(.bottom, 4 * scale)
            })
        })
        .aspectRatio(356/99.5, contentMode: .fit)
    }
}

struct ResultPlayer_Previews: PreviewProvider {
    static let result: RealmCoopPlayer = RealmCoopPlayer(dummy: true)
    static var previews: some View {
        ResultPlayer(result: result)
            .previewLayout(.fixed(width: 400, height: 120))
    }
}
