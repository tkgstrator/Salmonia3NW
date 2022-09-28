//
//  ResultPlayer.swift
//  Salmonia3+
//
//  Created by devonly on 2022/09/17.
//

import SwiftUI
import SplatNet3

struct ResultPlayer: View {
    @AppStorage("IS_USE_NAMEPLATE") var isUseNamePlate: Bool = false
    @Environment(\.isNameVisible) var isNameVisible: Bool
    let result: RealmCoopPlayer

    var body: some View {
        GeometryReader(content: { geometry in
            let scale: CGFloat = geometry.width / 356
            ZStack(alignment: .bottom, content: {
                Salmon()
                    .fill(SPColor.Theme.SPOrange)
                HStack(alignment: .bottom, spacing: 0, content: {
                    VStack(alignment: .center, spacing: 0, content: {
                        Text((isNameVisible || result.isMyself) ? result.name : "-")
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
