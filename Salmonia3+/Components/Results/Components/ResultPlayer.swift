//
//  ResultPlayer.swift
//  Salmonia3+
//
//  Created by tkgstrator on 2022/09/17.
//

import SwiftUI
import SplatNet3
import RealmSwift

struct ResultPlayers: View {
    @Environment(\.resultStyle) var resultStyle
    let result: RealmCoopResult

    var body: some View {
        let spacing: CGFloat = resultStyle == .SPLATNET2 ? 9 : 1
        let maximum: CGFloat = resultStyle == .SPLATNET2 ? 356 : 420
        LazyVGrid(
            columns: Array(repeating: .init(.flexible(maximum: maximum)), count: 1),
            alignment: .center,
            spacing: spacing,
            content: {
                let players: [RealmCoopPlayer] = {
                    guard let player: RealmCoopPlayer = result.players.first else {
                        return []
                    }
                    return [player] + Array(result.players.dropFirst().sorted(by: { $0.pid < $1.pid }))
                }()
                ForEach(players) { player in
                    switch resultStyle {
                    case .SPLATNET2:
                        ResultPlayerSplatNet2(result: player)
                    case .SPLATNET3:
                        ResultPlayerSplatNet3(result: player)
                            .cornerRadius(10, corners: players.corner(of: player))
                    }
                }
            })
        .padding(.horizontal, 10)
        .padding(.bottom, 15)
    }
}

private struct ResultPlayerSplatNet2: View {
    @Environment(\.isNameVisible) var isNameVisible: Bool
    let result: RealmCoopPlayer

    var body: some View {
        ZStack(alignment: .bottom, content: {
            Salmon()
                .fill(SPColor.SplatNet2.SPOrange)
            HStack(alignment: .bottom, spacing: 0, content: {
                VStack(alignment: .center, spacing: 0, content: {
                    VStack(alignment: .center, spacing: 0, content: {
                        Spacer()
                        Text((isNameVisible || result.isMyself) ? result.name : "-")
                            .foregroundColor(.white)
                            .shadow(color: .black, radius: 0, x: 1, y: 1)
                            .font(systemName: .Splatfont2, size: 17)
                            .frame(height: 18)
                    })
                    .frame(height: 43)
                    LazyVGrid(columns: Array(repeating: .init(.fixed(28), spacing: 2), count: result.weaponList.count + 1), content: {
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
                .padding(.leading, 12)
                .frame(width: 172)
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

private struct ResultPlayerSplatNet3: View {
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
                    Text((isNameVisible || result.isMyself) ? result.name : "-")
                        .foregroundColor(.white)
                        .font(systemName: .Splatfont2, size: 15)
                    HStack(alignment: .center, spacing: 0, content: {
                        Text(bundle: .CoopHistory_Enemy)
                        Text(String(format: "x%d", result.bossKillCountsTotal))
                    })
                    .shadow(color: Color.black.opacity(0.25), radius: 0, x: 1, y: 1)
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
                LazyVGrid(
                    columns: [.init(.flexible(minimum: 72, maximum: 80)), .init(.fixed(58.3))],
                    alignment: .leading,
                    spacing: 5,
                    content: {
                    HStack(alignment: .center, spacing: 0, content: {
                        Image(bundle: .GoldenIkura)
                            .resizable()
                            .scaledToFit()
                            .frame(width: 22, height: 16, alignment: .center)
                            .padding(.trailing, 2)
                        HStack(alignment: .bottom, spacing: 0, content: {
                            Text(String(format: "x%d", result.goldenIkuraNum))
                            Text(String(format: "<%d>", result.goldenIkuraAssistNum))
                                .font(systemName: .Splatfont2, size: 10)
                                .foregroundColor(Color.white.opacity(0.5))
                        })
                        .frame(maxWidth: .infinity, alignment: .leading)
                    })
                    .lineLimit(1)
                    .frame(minWidth: 72, maxWidth: 78.0)
                    HStack(alignment: .center, spacing: 2, content: {
                        Image(bundle: result.species == .INKLING ? RescueType.Inkling : RescueType.Octoling)
                            .resizable()
                            .scaledToFit()
                            .frame(width: 32, height: 16, alignment: .center)
                        Text(String(format: "x%d", result.helpCount))
                            .frame(maxWidth: .infinity, alignment: .trailing)
                    })
                    .frame(width: 58.3, height: 16, alignment: .center)
                    HStack(alignment: .center, spacing: 0, content: {
                        Image(bundle: .Ikura)
                            .resizable()
                            .scaledToFit()
                            .frame(width: 22, height: 16, alignment: .center)
                            .padding(.trailing, 2)
                        Text(String(format: "x%d", result.ikuraNum))
                            .frame(maxWidth: .infinity, alignment: .leading)
                    })
                    .frame(minWidth: 72, maxWidth: 78.0)
                    HStack(alignment: .center, spacing: 2, content: {
                        Image(bundle: result.species == .INKLING ? DeathType.Inkling : DeathType.Octoling)
                            .resizable()
                            .scaledToFit()
                            .frame(width: 32, height: 16, alignment: .center)
                        Text(String(format: "x%d", result.deadCount))
                            .frame(maxWidth: .infinity, alignment: .trailing)
                    })
                    .frame(width: 58.3, height: 16, alignment: .center)
                })
                .padding(4)
                .background(RoundedRectangle(cornerRadius: 10).fill(Color.black.opacity(0.7)))
                .foregroundColor(Color.white)
                .font(systemName: .Splatfont2, size: 12)
            })
            .padding(.trailing, 8)
        })
        .frame(height: 53.8)
    }
}

private extension Array where Element == RealmCoopPlayer {
    func corner(of target: RealmCoopPlayer) -> UIRectCorner {
        self.firstIndex(of: target) == 0 ? [.topLeft, .topRight] : self.firstIndex(of: target) == self.count - 1 ? [.bottomLeft, .bottomRight] : []
    }
}


struct ResultPlayer_Previews: PreviewProvider {
    static let result: RealmCoopResult = RealmCoopResult(dummy: true)

    static var previews: some View {
        ResultPlayers(result: result)
            .environment(\.resultStyle, .SPLATNET2)
            .previewLayout(.fixed(width: 375, height: 500))
        ResultPlayers(result: result)
            .environment(\.resultStyle, .SPLATNET3)
            .previewLayout(.fixed(width: 375, height: 500))
    }
}
