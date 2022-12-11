//
//  ResultView.swift
//  Salmonia3+
//  
//  Created by devonly on 2022/12/08
//  Copyright © 2022 Magi Corporation. All rights reserved.
//

import Foundation
import SwiftUI
import RealmSwift
import SplatNet3

struct ResultView: View {
    let result: RealmCoopResult

    var body: some View {
        ScrollView(.vertical, showsIndicators: false, content: {
            VStack(spacing: 0, content: {
                _ResultHeader()
                _ResultStatus()
                _ResultWave()
                _ResultPlayer()
                _ResultEnemy()
            })
        })
        .background(content: {
            SPColor.SplatNet3.SPBackground.ignoresSafeArea()
        })
        .navigationBarTitleDisplayMode(.inline)
        .environment(\.coopResult, result)
    }
}

private struct _ResultHeader: View {
    @Environment(\.coopResult) var result
    let dateFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateFormat = LocalizedType.Widgets_StagesYearDatetimeFormat.localized
        return formatter
    }()

    func Header() -> some View {
        HStack(content: {
            Text(dateFormatter.string(from: result.playTime))
                .font(systemName: .Splatfont2, size: 10)
                .foregroundColor(.white)
                .padding(.vertical, 3)
                .padding(.horizontal, 10)
                .background(content: {
                    Color.black
                })
            Spacer()
            Text(result.schedule.stageId)
                .font(systemName: .Splatfont2, size: 10)
                .foregroundColor(.white)
                .padding(.vertical, 3)
                .padding(.horizontal, 10)
                .background(content: {
                    Color.black
                })
        })
        .frame(maxWidth: 440)
        .padding(.top, 5)
        .padding(.leading, 5)
    }

    func WeaponView() -> some View {
        let schedule: RealmCoopSchedule = result.schedule
        return HStack(content: {
            /// ブキ画像はスペースが0
            HStack(spacing: 0, content: {
                ForEach(schedule.weaponList.indices, id: \.self, content: { index in
                    let weaponId: WeaponId = schedule.weaponList[index]
                    Image(weaponId)
                        .resizable()
                        .scaledToFit()
                        .frame(width: 25, height: 25, alignment: .center)
                })
            })
            .padding(.trailing, 15)
            Text(bundle: .CoopHistory_DangerRatio)
                .font(systemName: .Splatfont2, size: 10)
                .foregroundColor(.white.opacity(0.6))
            Text(String(format: "%d%%", (result.dangerRate * 100).intValue))
                .font(systemName: .Splatfont, size: 15)
                .foregroundColor(.white)
        })
        .padding(.horizontal, 14)
        .background(alignment: .center, content: {
            RoundedRectangle(cornerRadius: 20)
                .fill(SPColor.SplatNet3.SPDark)
                .frame(height: 30, alignment: .center)
        })
    }

    var body: some View {
        Image(result.schedule.stageId, size: .Header)
            .resizable()
            .scaledToFit()
            .overlay(alignment: .center, content: {
                Text(bundle: result.isClear ? .CoopHistory_Clear : .CoopHistory_Failure)
                    .font(systemName: .Splatfont, size: 25)
                    .foregroundColor(SPColor.SplatNet3.SPSalmonGreen)
            })
            .overlay(alignment: .top, content: {
                Header()
            })
            .padding(.bottom, 15)
            .overlay(alignment: .bottom, content: {
                WeaponView()
            })
            .padding(.bottom, 15)
    }
}

private struct _ResultStatus: View {
    @Environment(\.coopResult) var result

    func ResultStatus() -> some View {
        VStack(alignment: .leading, spacing: 0, content: {
            HStack(spacing: 4, content: {
                Text(result.grade)
                Text(result.gradePoint)
            })
            .font(systemName: .Splatfont2, size: 12)
            .foregroundColor(SPColor.SplatNet3.SPSalmonGreen)
            .padding(.bottom, 5)
            GeometryReader(content: { geometry in
                ZStack(alignment: .leading, content: {
                    RoundedRectangle(cornerRadius: 10)
                        .fill(SPColor.SplatNet3.SPBackground)
                        .frame(width: geometry.frame(in: .local).width, height: 10)
                    RoundedRectangle(cornerRadius: 10)
                        .frame(width: geometry.frame(in: .local).width * 0.35, height: 10)
                        .foregroundColor(SPColor.SplatNet3.SPSalmonOrange)
                })
                .padding(.bottom, 10)
            })
            HStack(alignment: .bottom, spacing: nil, content: {
                HStack(spacing: 4, content: {
                    Image(icon: .GoldenIkura)
                        .resizable()
                        .scaledToFit()
                        .frame(width: 16, height: 16)
                    Text(String(format: "x%d", result.goldenIkuraNum))
                        .font(systemName: .Splatfont2, size: 12)
                        .foregroundColor(Color.white)
                })
                HStack(spacing: 4, content: {
                    Image(icon: .Ikura)
                        .resizable()
                        .scaledToFit()
                        .frame(width: 22, height: 16)
                    Text(String(format: "x%d", result.ikuraNum))
                        .font(systemName: .Splatfont2, size: 12)
                        .foregroundColor(Color.white)
                })
            })
            .padding(.bottom, 5)
            HStack(alignment: .bottom, spacing: nil, content: {
                ForEach(ScaleType.allCases, content: { scale in
                    HStack(spacing: 4, content: {
                        Image(scale)
                            .resizable()
                            .scaledToFit()
                            .frame(width: 16, height: 16)
                        Text(String(format: "x%d", result.scale[scale.rawValue]))
                            .font(systemName: .Splatfont2, size: 12)
                            .foregroundColor(Color.white)
                    })
                })
            })
        })
        .padding(10)
        .frame(maxWidth: 205.5)
        .background(content: {
            Color.black.opacity(0.7)
        })
        .cornerRadius(10, corners: .allCorners)
    }

    func GridStatus() -> some View {
        HStack(spacing: 0, content: {
            VStack(content: {
                Text(String(format: "%d", result.jobScore))
                    .font(systemName: .Splatfont2, size: 15)
                    .foregroundColor(Color.white)
                Text(bundle: .CoopHistory_Score)
                    .font(systemName: .Splatfont2, size: 10)
                    .foregroundColor(SPColor.SplatNet2.SPWhite)
            })
            .frame(maxWidth: .infinity)
            Text("x")
                .font(systemName: .Splatfont2, size: 15)
                .foregroundColor(SPColor.SplatNet2.SPWhite)
            VStack(content: {
                Text(String(format: "%@", result.jobRate))
                    .font(systemName: .Splatfont2, size: 15)
                    .foregroundColor(Color.white)
                Text(bundle: .CoopHistory_JobRatio)
                    .font(systemName: .Splatfont2, size: 10)
                    .foregroundColor(SPColor.SplatNet2.SPWhite)
            })
            .frame(maxWidth: .infinity)
            Text("+")
                .font(systemName: .Splatfont2, size: 15)
                .foregroundColor(SPColor.SplatNet2.SPWhite)
                .lineLimit(1)
            VStack(content: {
                Text(String(format: "%d", result.jobBonus))
                    .font(systemName: .Splatfont2, size: 15)
                    .foregroundColor(Color.white)
                    .lineLimit(1)
                Text(bundle: .CoopHistory_Bonus)
                    .font(systemName: .Splatfont2, size: 10)
                    .foregroundColor(SPColor.SplatNet2.SPWhite)
                    .lineLimit(1)
            })
            .frame(maxWidth: .infinity)
        })
        .frame(maxWidth: 205.5)
    }

    func PointStatus() -> some View {
        VStack(alignment: .center, spacing: 1, content: {
            HStack(content: {
                Text(bundle: .CoopHistory_JobPoint)
                    .font(systemName: .Splatfont2, size: 12)
                    .foregroundColor(SPColor.SplatNet2.SPWhite)
                Spacer()
                Text(String(format: "%dp", result.kumaPoint))
                    .font(systemName: .Splatfont2, size: 18)
                    .foregroundColor(Color.white)
            })
            .padding(10)
            .frame(height: 47.5)
            .background(content: {
                Color.black.opacity(0.7)
            })
            .cornerRadius(10, corners: [.topLeft, .topRight])
            VStack(content: {
                GridStatus()
            })
            .padding(10)
            .frame(height: 48.0)
            .background(content: {
                Color.black.opacity(0.7)
            })
            .cornerRadius(10, corners: [.bottomLeft, .bottomRight])
        })
        .frame(maxWidth: 205.5)
    }

    var body: some View {
        HStack(content: {
            ResultStatus()
                .frame(height: 96.5)
            PointStatus()
                .frame(height: 96.5)
        })
        .padding(.horizontal, 10)
        .padding(.bottom, 15)
    }
}

private struct _ResultEnemy: View {
    @Environment(\.coopResult) var result

    var body: some View {
        VStack(spacing: 0, content: {
            ForEach(EnemyId.allCases.dropLast(1), content: { enemyId in
                let index: Int = EnemyId.allCases.firstIndex(of: enemyId) ?? 0
                let bossCount: Int = result.bossCounts[index]
                let bossKillCount: Int = result.bossKillCounts[index]
                let playerBossKillCount: Int = result.players.first?.bossKillCounts[index] ?? 0
                if bossCount != .zero {
                    HStack(content: {
                        Image(enemyId)
                            .resizable()
                            .scaledToFit()
                            .frame(width: 45, height: 45)
                            .padding(.trailing, 5)
                        Text(enemyId)
                            .font(systemName: .Splatfont2, size: 15)
                            .foregroundColor(Color.white)
                        Spacer()
                        HStack(alignment: .bottom, spacing: 0, content: {
                            Text(String(format: "%d", bossKillCount))
                                .font(systemName: .Splatfont2, size: 15)
                                .padding(.trailing, 2)
                            Text(String(format: "(%d)", playerBossKillCount))
                                .font(systemName: .Splatfont2, size: 11)
                            Spacer()
                            Text("/")
                            Spacer()
                            Text(String(format: "x%d", bossCount))
                                .font(systemName: .Splatfont2, size: 15)
                        })
                        .frame(width: 80)
                        .foregroundColor(bossCount == bossKillCount ? Color.yellow : Color.white)
                    })
                }
            })
        })
        .frame(maxWidth: 340)
    }
}

private struct _ResultWave: View {
    @Environment(\.coopResult) var result: RealmCoopResult

    func ResultSpecial(specialUsage: [SpecialId]) -> some View {
        HStack(spacing: 0, content: {
            ForEach(specialUsage.indices, id: \.self, content: { index in
                let specialId: SpecialId = specialUsage[index]
                Image(specialId)
                    .resizable()
                    .scaledToFit()
                    .frame(width: 14.4, height: 14.4, alignment: .center)
                    .padding(1.8)
                    .background(content: {
                        Color.black
                    })
                    .clipShape(RoundedRectangle(cornerRadius: 5))
                    .padding([.bottom, .trailing], 3)
            })
        })
    }

    func ResultWave(wave: RealmCoopWave) -> some View {
        VStack(spacing: 0, content: {
            Text(String(format: "WAVE %d", wave.id))
                .font(systemName: .Splatfont2, size: 13)
                .foregroundColor(Color.black)
                .padding(.top, 7)
                .padding(.bottom, 4)
                .frame(height: 24)
            if let goldenIkuraNum = wave.goldenIkuraNum, let quotaNum = wave.quotaNum {
                Text(String(format: "%d/%d", goldenIkuraNum, quotaNum))
                    .font(systemName: .Splatfont2, size: 17)
                    .foregroundColor(Color.white)
                    .frame(height: 25)
                    .frame(maxWidth: .infinity)
                    .background(content: {
                        Color.black.opacity(0.8)
                    })
            } else {
                Text(result.bossId ?? .SakelienGiant)
                    .font(systemName: .Splatfont2, size: 17)
                    .foregroundColor(SPColor.SplatNet3.SPSalmonGreen)
                    .frame(height: 25)
                    .frame(maxWidth: .infinity)
                    .background(content: {
                        Color.black.opacity(0.8)
                    })
            }
            Text(wave.waterLevel)
                .font(systemName: .Splatfont2, size: 12)
                .foregroundColor(Color.black)
                .padding(.vertical, 6)
            Text(wave.eventType)
                .font(systemName: .Splatfont2, size: 12)
                .foregroundColor(Color.black)
            Spacer()
            HStack(spacing: 4, content: {
                Image(icon: .GoldenIkura)
                    .resizable()
                    .scaledToFit()
                    .frame(width: 16, height: 16, alignment: .center)
                Text(String(format: "x%d", wave.goldenIkuraPopNum))
                    .font(systemName: .Splatfont2, size: 11)
                    .foregroundColor(Color.black.opacity(0.6))
            })
            Text(bundle: .CoopHistory_Available)
                .font(systemName: .Splatfont2, size: 9)
                .foregroundColor(Color.black.opacity(0.6))
                .padding(.bottom, 5)
        })
        .frame(height: 135)
        .background(content: {
            SPColor.SplatNet3.SPYellow
        })
    }

    var body: some View {
        LazyVGrid(columns: Array(repeating: .init(.flexible(maximum: 105), spacing: 1, alignment: .top), count: result.waves.count),
                  alignment: .center,
                  content: {
            ForEach(result.waves, content: { wave in
                let isFirst: Bool = result.waves.first == wave
                let isLast: Bool = result.waves.last == wave
                VStack(spacing: 0, content: {
                    ResultWave(wave: wave)
                        .cornerWaveRadius(10, isFirst: isFirst, isLast: isLast)
                    ResultSpecial(specialUsage: [.SpChariot, .SpJetpack, .SpMicroLaser])
                        .padding(.top, 5)
                })
            })
        })
        .padding(.bottom, 15)
        .padding(.horizontal, 10)
    }
}

private struct _ResultPlayer: View {
    @Environment(\.coopResult) var result: RealmCoopResult

    func ResultStatus(player: RealmCoopPlayer) -> some View {
        HStack(spacing: 5, content: {
            VStack(alignment: .leading, spacing: 5, content: {
                HStack(spacing: 0, content: {
                    Image(icon: .GoldenIkura)
                        .resizable()
                        .scaledToFit()
                        .frame(width: 22, height: 16)
                    Text(String(format: "x%d", player.goldenIkuraNum))
                        .font(systemName: .Splatfont2, size: 12)
                        .foregroundColor(Color.white)
                })
                HStack(spacing: 0, content: {
                    Image(icon: .Ikura)
                        .resizable()
                        .scaledToFit()
                        .frame(width: 22, height: 16)
                    Text(String(format: "x%d", player.ikuraNum))
                        .font(systemName: .Splatfont2, size: 12)
                        .foregroundColor(Color.white)
                })
            })
            .frame(minWidth: 50)
            VStack(alignment: .leading, spacing: 5, content: {
                HStack(spacing: 0, content: {
                    Image(icon: .GoldenIkura)
                        .resizable()
                        .scaledToFit()
                        .frame(width: 32, height: 16)
                    Text(String(format: "x%d", player.helpCount))
                        .font(systemName: .Splatfont2, size: 12)
                        .foregroundColor(Color.white)
                })
                HStack(spacing: 0, content: {
                    Image(icon: .Ikura)
                        .resizable()
                        .scaledToFit()
                        .frame(width: 32, height: 16)
                    Text(String(format: "x%d", player.deadCount))
                        .font(systemName: .Splatfont2, size: 12)
                        .foregroundColor(Color.white)
                })
            })
            .frame(minWidth: 53)
        })
        .padding(4)
        .background(content: {
            Color.black.opacity(0.7)
        })
        .cornerRadius(10, corners: .allCorners)
    }

    var body: some View {
        VStack(spacing: 1, content: {
            ForEach(result.players, content: { player in
                let isFirst: Bool = result.players.first == player
                let isLast: Bool = result.players.last == player
                HStack(content: {
                    VStack(alignment: .leading, spacing: 0, content: {
                        Text(player.name)
                            .font(systemName: .Splatfont2, size: 15)
                            .foregroundColor(Color.white)
                        Text(String(format: "%@ x%d", LocalizedType.CoopHistory_Enemy.localized, player.bossKillCountsTotal))
                            .font(systemName: .Splatfont2, size: 11)
                            .foregroundColor(Color.white.opacity(0.7))
                    })
                    Spacer()
                    ResultStatus(player: player)
                })
                .padding(.horizontal, 10)
                .padding(.vertical, 6)
                .frame(maxWidth: 420)
                .background(content: {
                    SPColor.SplatNet3.SPSalmonOrange
                        .cornerPlayerRadius(10, isFirst: isFirst, isLast: isLast)
                })
            })
        })
        .padding(.horizontal, 10)
        .padding(.bottom, 15)
    }
}

fileprivate extension View {
    func cornerPlayerRadius(_ radius: CGFloat, isFirst: Bool, isLast: Bool) -> some View {
        switch (isFirst, isLast) {
        case (true, false):
            return self.cornerRadius(10, corners: [.topLeft, .topRight])
        case (false, true):
            return self.cornerRadius(10, corners: [.bottomLeft, .bottomRight])
        default:
            return self.cornerRadius(10, corners: [])
        }
    }

    func cornerWaveRadius(_ radius: CGFloat, isFirst: Bool, isLast: Bool) -> some View {
        switch (isFirst, isLast) {
        case (true, false):
            return self.cornerRadius(10, corners: [.topLeft, .bottomLeft])
        case (false, true):
            return self.cornerRadius(10, corners: [.topRight, .bottomRight])
        case (true, true):
            return self.cornerRadius(10, corners: .allCorners)
        default:
            return self.cornerRadius(10, corners: [])
        }
    }
}

struct ResultView_Previews: PreviewProvider  {
    static let result: RealmCoopResult = RealmCoopResult.preview

    static var previews: some View {
        ResultView(result: result)
    }
}

struct ScheduleView_Previews: PreviewProvider {
    static let result: RealmCoopResult = RealmCoopResult.preview

    static var previews: some View {
        _ResultHeader()
            .environment(\.coopResult, result)
    }
}
