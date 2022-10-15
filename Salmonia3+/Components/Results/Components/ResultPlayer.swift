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

struct ResultPlayerSplatNet2: View {
    let result: RealmCoopPlayer

    var body: some View {
        ZStack(alignment: .bottom, content: {
            Salmon()
                .fill(SPColor.SplatNet2.SPOrange)
            HStack(alignment: .bottom, spacing: 0, content: {
                VStack(alignment: .center, spacing: 0, content: {
                    VStack(alignment: .center, spacing: 0, content: {
                        Spacer()
                        Text(result.name)
                            .foregroundColor(.white)
                            .shadow(color: .black, radius: 0, x: 1, y: 1)
                            .font(systemName: .Splatfont2, size: 17)
                            .frame(height: 18)
                    })
                    .frame(height: 43)
                    LazyVGrid(columns: Array(repeating: .init(.fixed(28), spacing: 2), count: 5), content: {
                        ForEach(result.weaponList.indices, id: \.self) { index in
                            let weapon: WeaponType = result.weaponList[index]
                            Image(bundle: weapon)
                                .resizable()
                                .scaledToFit()
                                .frame(width: 28, height: 28, alignment: .center)
                                .background(Circle().fill(Color.black))
                        }
                        Image(bundle: result.specialId ?? .SpUltraShot)
                            .resizable()
                            .scaledToFit()
                            .frame(width: 28, height: 28, alignment: .center)
                            .background(Circle().fill(Color.black))
                    })
                    .padding(.vertical, 6)
                    HStack(alignment: .center, spacing: 2, content: {
                        Text(bundle: .CoopHistory_Enemy)
                        Text(String(format: "x%d", result.bossKillCountsTotal))
                    })
                    .font(systemName: .Splatfont2, size: 11)
                    .foregroundColor(SPColor.SplatNet2.SPYellow)
                    .shadow(color: .black, radius: 0, x: 1, y: 1)
                    .frame(height: 11)
                })
                .frame(width: 172)
                .padding(.leading, 12)
                Spacer()
                LazyVGrid(columns: Array(repeating: .init(.flexible(maximum: 78.5), spacing: 3), count: 2), spacing: 3, content: {
                    ZStack(content: {
                        RoundedRectangle(cornerRadius: 12)
                            .fill(Color.black.opacity(0.75))
                        HStack(alignment: .center, spacing: 0, content: {
                            Image(bundle: .GoldenIkura)
                                .resizable()
                                .scaledToFit()
                                .frame(width: 18, height: 18, alignment: .center)
                            Spacer()
                            Text(String(format: "x%d", result.goldenIkuraNum))
                        })
                        .padding(.horizontal, 6)
                    })
                    .frame(width: 78.5, height: 24, alignment: .center)
                    ZStack(content: {
                        RoundedRectangle(cornerRadius: 12)
                            .fill(Color.black.opacity(0.75))
                        HStack(alignment: .center, spacing: 0, content: {
                            Image(bundle: .Ikura)
                                .resizable()
                                .scaledToFit()
                                .frame(width: 20.5, height: 15, alignment: .center)
                            Spacer()
                            Text(String(format: "x%d", result.ikuraNum))
                        })
                        .padding(.horizontal, 6)
                    })
                    .frame(width: 78.5, height: 24, alignment: .center)
                    ZStack(content: {
                        RoundedRectangle(cornerRadius: 12)
                            .fill(Color.black.opacity(0.75))
                        HStack(alignment: .center, spacing: 0, content: {
                            Image(bundle: ButtonType.Rescue)
                                .resizable()
                                .scaledToFit()
                                .frame(width: 33.4, height: 12.8, alignment: .center)
                            Spacer()
                            Text(String(format: "x%d", result.helpCount))
                        })
                        .padding(.horizontal, 6)
                    })
                    .frame(width: 78.5, height: 24, alignment: .center)
                    ZStack(content: {
                        RoundedRectangle(cornerRadius: 12)
                            .fill(Color.black.opacity(0.75))
                        HStack(alignment: .center, spacing: 0, content: {
                            Image(bundle: ButtonType.Death)
                                .resizable()
                                .scaledToFit()
                                .frame(width: 30.8, height: 12.8, alignment: .center)
                            Spacer()
                            Text(String(format: "x%d", result.deadCount))
                        })
                        .padding(.horizontal, 6)
                    })
                    .frame(width: 78.5, height: 24, alignment: .center)
                })
                .foregroundColor(SPColor.SplatNet2.SPWhite)
                .font(systemName: .Splatfont2, size: 13)
                .frame(width: 160, height: 51, alignment: .center)
            })
            .padding(.trailing, 12)
            .padding(.bottom, 4)
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
            Rectangle()
                .fill(SPColor.SplatNet3.SPSalmonOrange)
                .frame(height: 53.8)
            HStack(alignment: .center, spacing: 0, content: {
                VStack(alignment: .leading, spacing: 0, content: {
                    Text(result.name)
                        .foregroundColor(.white)
                        .font(systemName: .Splatfont2, size: 15)
                    HStack(alignment: .center, spacing: 0, content: {
                        Text(bundle: .CoopHistory_Enemy)
                        Text(String(format: "x%d", result.bossKillCountsTotal))
                    })
                    .foregroundColor(Color.white.opacity(0.7))
                    .font(systemName: .Splatfont2, size: 11)
                })
                .padding(10)
                Spacer()
                LazyVGrid(columns: Array(repeating: .init(.fixed(18), spacing: 2), count: 3), spacing: 2, content: {
                    ForEach(result.weaponList.indices, id: \.self) { index in
                        let weapon: WeaponType = result.weaponList[index]
                        Image(bundle: weapon)
                            .resizable()
                            .scaledToFit()
                            .padding(2)
                            .frame(width: 18, height: 18, alignment: .center)
                            .background(Circle().fill(Color.black))
                    }
                    Image(bundle: result.specialId ?? .SpUltraShot)
                        .resizable()
                        .scaledToFit()
                        .padding(1)
                        .frame(width: 18, height: 18, alignment: .center)
                        .background(RoundedRectangle(cornerRadius: 4.7988).fill(Color.black))
                })
                .frame(width: 58, height: 38, alignment: .center)
                .padding(.trailing, 8)
                ZStack(alignment: .center, content: {
                    RoundedRectangle(cornerRadius: 10)
                        .fill(Color.black.opacity(0.7))
                    LazyVGrid(columns: Array(repeating: .init(.fixed(58.3), spacing: 2), count: 2), alignment: .leading, spacing: 5, content: {
                        HStack(alignment: .center, spacing: 2, content: {
                            Image(bundle: .GoldenIkura)
                                .resizable()
                                .scaledToFit()
                                .frame(width: 22, height: 16, alignment: .center)
                            Text(String(format: "x%d", result.goldenIkuraNum))
                                .frame(maxWidth: .infinity, alignment: .trailing)
                        })
                        .frame(width: 58.3, height: 16, alignment: .center)
                        HStack(alignment: .center, spacing: 2, content: {
                            Image(bundle: ButtonType.Rescue)
                                .resizable()
                                .scaledToFit()
                                .frame(width: 32, height: 16, alignment: .center)
                            Text(String(format: "x%d", result.helpCount))
                                .frame(maxWidth: .infinity, alignment: .trailing)
                        })
                        .frame(width: 58.3, height: 16, alignment: .center)
                        HStack(alignment: .center, spacing: 2, content: {
                            Image(bundle: .Ikura)
                                .resizable()
                                .scaledToFit()
                                .frame(width: 22, height: 16, alignment: .center)
                            Text(String(format: "x%d", result.ikuraNum))
                                .frame(maxWidth: .infinity, alignment: .trailing)
                        })
                        .frame(width: 58.3, height: 16, alignment: .center)
                        HStack(alignment: .center, spacing: 2, content: {
                            Image(bundle: ButtonType.Death)
                                .resizable()
                                .scaledToFit()
                                .frame(width: 32, height: 16, alignment: .center)
                            Text(String(format: "x%d", 2))
                                .frame(maxWidth: .infinity, alignment: .trailing)
                        })
                        .frame(width: 58.3, height: 16, alignment: .center)
                    })
                    .frame(width: 118.18, height: 45, alignment: .center)
                    .foregroundColor(Color.white)
                    .font(systemName: .Splatfont2, size: 12)
                })
                .frame(width: 128.93, height: 45, alignment: .center)
            })
            .padding(.trailing, 8)
        })
        .frame(height: 53.8)
    }
}

struct ResultPlayer_Previews: PreviewProvider {
    static let result: RealmCoopPlayer = RealmCoopPlayer(dummy: true)
    static var previews: some View {
        ResultPlayerSplatNet2(result: result)
            .previewLayout(.fixed(width: 356, height: 120))
        ResultPlayerSplatNet3(result: result)
            .previewLayout(.fixed(width: 356, height: 80))
    }
}
