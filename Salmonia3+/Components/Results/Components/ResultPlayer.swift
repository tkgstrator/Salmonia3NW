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
                    .fill(SPColor.SplatNet2.SPOrange)
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
                    VStack(alignment: .trailing, spacing: 2 * scale, content: {
                        ResultEgg(ikuraNum: result.ikuraNum, goldenIkuraNum: result.goldenIkuraNum, goldenIkuraAssistNum: result.goldenIkuraAssistNum)
                        ResultStatus(deadCount: result.deadCount, helpCount: result.helpCount)
                    })
                    .frame(width: 160 * scale, height: 51 * scale)
                    .padding(.trailing, 16 * scale)
                })
                .padding(.bottom, 4 * scale)
            })
        })
        .aspectRatio(356/99.5, contentMode: .fit)
    }
}

struct ResultPlayerSplatNet3: View {
    @AppStorage("IS_USE_NAMEPLATE") var isUseNamePlate: Bool = false
    @Environment(\.isNameVisible) var isNameVisible: Bool
    let result: RealmCoopPlayer

    var body: some View {
        ZStack(alignment: .center, content: {
            Rectangle().fill(SPColor.SplatNet3.SPSalmonOrange)
            HStack(alignment: .center, spacing: nil, content: {
                VStack(alignment: .leading, spacing: nil, content: {
                    Text(result.name)
                        .foregroundColor(.white)
                        .font(systemName: .Splatfont2, size: 17)
                        .lineLimit(1)
                    HStack(spacing: 4, content: {
                        Text(bundle: .CoopHistory_Enemy)
                        Text(String(format: "x%d", result.bossKillCountsTotal))
                    })
                    .font(systemName: .Splatfont2, size: 12)
                    .foregroundColor(SPColor.SplatNet3.SPGreen)
                })
                Spacer()
                VStack(alignment: .leading, spacing: 2, content: {
                    HStack(spacing: 4, content: {
                        ForEach(result.weaponList, id:\.rawValue) { weaponId in
                            Image(bundle: weaponId)
                                .resizable()
                                .scaledToFit()
                                .frame(width: 22, height: 22, alignment: .center)
                                .background(Circle().fill(Color.black))
                        }
                    })
                    Image(bundle: result.specialId ?? .SpUltraShot)
                        .resizable()
                        .scaledToFit()
                        .frame(width: 22, height: 22, alignment: .center)
                        .background(RoundedRectangle(cornerRadius: 4).fill(Color.black))
                })
                Spacer()
                LazyVGrid(columns: [
                    .init(.fixed(75), spacing: 2, alignment: .leading),
                    .init(.fixed(60), spacing: 2, alignment: .leading)
                ], spacing: 4, content: {
                    HStack(alignment: .center, spacing: 2, content: {
                        Image(bundle: .GoldenIkura)
                            .resizable()
                            .scaledToFit()
                            .frame(width: 28, height: 24, alignment: .center)
                        Text(String(format: "x%d", result.goldenIkuraNum))
                    })
                    HStack(alignment: .center, spacing: 2, content: {
                        Image(bundle: ButtonType.Rescue)
                            .resizable()
                            .scaledToFit()
                            .frame(width: 34, height: 24, alignment: .center)
                        Text(String(format: "x%d", result.helpCount))
                    })
                    HStack(alignment: .center, spacing: 2, content: {
                        Image(bundle: .Ikura)
                            .resizable()
                            .scaledToFit()
                            .frame(width: 28, height: 24, alignment: .center)
                        Text(String(format: "x%d", result.ikuraNum))
                    })
                    HStack(alignment: .center, spacing: 2, content: {
                        Image(bundle: ButtonType.Death)
                            .resizable()
                            .scaledToFit()
                            .frame(width: 34, height: 24, alignment: .center)
                        Text(String(format: "x%d", result.deadCount))
                    })
                })
                .foregroundColor(.white)
                .font(systemName: .Splatfont2, size: 14)
                .padding(4)
                .background(RoundedRectangle(cornerRadius: 10).fill(SPColor.SplatNet3.SPBackground))
            })
            .padding(.horizontal, 8)
        })
        .aspectRatio(400/70, contentMode: .fit)
    }
}

struct ResultPlayer_Previews: PreviewProvider {
    static let result: RealmCoopPlayer = RealmCoopPlayer(dummy: true)
    static var previews: some View {
        ResultPlayer(result: result)
            .previewLayout(.fixed(width: 400, height: 120))
        ResultPlayerSplatNet3(result: result)
            .previewLayout(.fixed(width: 400, height: 70))
    }
}
