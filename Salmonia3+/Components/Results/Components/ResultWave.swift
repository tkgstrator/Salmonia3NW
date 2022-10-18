//
//  CoopWave.swift
//  Salmonia3+
//
//  Created by devonly on 2022/09/17.
//

import SwiftUI
import SplatNet3
import RealmSwift

struct ResultWaves: View {
    @Environment(\.resultStyle) var resultStyle
    let result: RealmCoopResult

    var body: some View {
        let spacing: CGFloat = resultStyle == .SPLATNET2 ? 8 : 1
        let maximum: CGFloat = resultStyle == .SPLATNET2 ? 123.99 : 105
        LazyVGrid(
            columns: Array(repeating: .init(.flexible(maximum: maximum), spacing: spacing, alignment: .top), count: result.waves.count),
            alignment: .center,
            spacing: spacing,
            content: {
            ForEach(result.waves) { wave in
                switch resultStyle {
                case .SPLATNET2:
                    VStack(alignment: .center, spacing: 0, content: {
                        ResultWaveSplatNet2(wave: wave)
                        ResultSpecial(result: wave)
                    })
                case .SPLATNET3:
                    VStack(alignment: .center, spacing: 5, content: {
                        ResultWaveSplatNet3(wave: wave)
                            .cornerRadius(10, corners: result.waves.corner(of: wave))
                            .overlay(WaveResult(isClear: wave.isClearWave).offset(x: -2, y: -7), alignment: .topTrailing)
                        ResultSpecial(result: wave)
                    })
                }
            }
        })
        .padding(.bottom, 15)
        .padding(.horizontal, 10)
    }
}

private extension View {
    func waterLevelSP2(waterLevel: WaterType) -> some View {
        let height: CGFloat = {
            switch waterLevel {
            case .Low_Tide:
                return 151.98 * (1 - 0.1)
            case .Middle_Tide:
                return 151.98 * (1 - 0.24)
            case .High_Tide:
                return 151.98 * (1 - 0.45)
            }
        }()
        return self.overlay(Image(bundle: .Wave)
            .resizable()
            .opacity(0.2)
            .offset(x: 0, y: height),
                     alignment: .bottom)
            .clipped()
    }

    func waterLevelSP3(waterLevel: WaterType) -> some View {
        let height: CGFloat = {
            switch waterLevel {
            case .Low_Tide:
                return 135 * (1 - 0.10)
            case .Middle_Tide:
                return 135 * (1 - 0.30)
            case .High_Tide:
                return 135 * (1 - 0.50)
            }
        }()
        return self.overlay(Image(bundle: .Wave)
            .resizable()
            .opacity(0.2)
            .offset(x: 0, y: height),
                     alignment: .bottom)
            .clipped()
    }
}

private struct ResultWaveSplatNet2: View {
    let wave: RealmCoopWave

    var body: some View {
        ZStack(content: {
            RoundedRectangle(cornerRadius: 3)
                .fill(SPColor.SplatNet2.SPYellow)
                .mask(Image(bundle: .Hanger).resizable().scaledToFill().clipped())
                .overlay(Image(bundle: .WAVE).resizable())
                .waterLevelSP2(waterLevel: wave.waterLevel)
            VStack(alignment: .center, spacing: 0, content: {
                Text(bundle: wave.localizedText)
                    .font(systemName: .Splatfont2, size: 17)
                    .foregroundColor(.black)
                    .padding(.bottom, 3)
                ZStack(alignment: .center, content: {
                    Rectangle().fill(SPColor.SplatNet2.SPBackground)
                        .frame(height: 36.5)
                    if let goldenIkuraNum: Int = wave.goldenIkuraNum, let quotaNum: Int = wave.quotaNum {
                        Text(String(format: "%d/%d", goldenIkuraNum, quotaNum))
                            .foregroundColor(.white)
                            .font(systemName: .Splatfont2, size: 25)
                    } else {
                        Text(bundle: .CoopHistory_KingSakelien3)
                            .foregroundColor(SPColor.SplatNet3.SPSalmonGreen)
                            .font(systemName: .Splatfont2, size: 25)
                    }
                })
                .padding(.bottom, 6)
                Text(wave.waterLevel.localizedText)
                    .foregroundColor(.black)
                    .font(systemName: .Splatfont2, size: 14)
                    .padding(.top, 8)
                Text(wave.eventType.localizedText)
                    .foregroundColor(.black)
                    .font(systemName: .Splatfont2, size: 14)
                    .padding(.top, 8)
            })
        })
        .aspectRatio(123.99/151.98, contentMode: .fit)
    }
}

private struct WaveResult: View {
    let isClear: Bool

    var body: some View {
        let color: Color = isClear ? SPColor.SplatNet3.SPGreen : SPColor.SplatNet3.SPSalmonOrange
        let localizedText: LocalizedText = isClear ? .CoopHistory_Gj : .CoopHistory_Ng

        Text(bundle: localizedText)
            .foregroundColor(color)
            .font(systemName: .Splatfont2, size: 12)
            .frame(height: 12 * 1.4)
            .padding(.horizontal, 4)
            .background(RoundedRectangle(cornerRadius: 30).fill(Color.black.opacity(0.8)))
    }
}

private struct ResultWaveSplatNet3: View {
    let wave: RealmCoopWave

    var body: some View {
        ZStack(content: {
            Rectangle()
                .fill(SPColor.SplatNet3.SPYellow)
                .waterLevelSP3(waterLevel: wave.waterLevel)
            VStack(alignment: .center, spacing: 0, content: {
                Text(bundle: wave.localizedText)
                    .font(systemName: .Splatfont2, size: 13)
                    .foregroundColor(.black)
                    .padding(.top, 7)
                    .padding(.bottom, 4)
                ZStack(alignment: .center, content: {
                    Rectangle().fill(Color.black.opacity(0.8))
                    if let goldenIkuraNum: Int = wave.goldenIkuraNum, let quotaNum: Int = wave.quotaNum {
                        Text(String(format: "%d/%d", goldenIkuraNum, quotaNum))
                            .foregroundColor(.white)
                            .font(systemName: .Splatfont2, size: 17)
                    } else {
                        Text(bundle: .CoopHistory_KingSakelien3)
                            .foregroundColor(SPColor.SplatNet3.SPSalmonGreen)
                            .font(systemName: .Splatfont2, size: 17)
                    }
                })
                .frame(height: 25)
                VStack(alignment: .center, spacing: 0, content: {
                    Text(wave.waterLevel.localizedText)
                        .foregroundColor(.black)
                        .font(systemName: .Splatfont2, size: 12)
                        .padding(.bottom, 6)
                    Text(wave.eventType.localizedText)
                        .foregroundColor(.black)
                        .font(systemName: .Splatfont2, size: 12)
                        .padding(.bottom, 6)
                })
                .padding(.top, 4)
                VStack(alignment: .center, spacing: 0, content: {
                    HStack(alignment: .center, spacing: 2, content: {
                        Image(bundle: .GoldenIkura)
                            .resizable()
                            .scaledToFit()
                            .frame(width: 16, height: 16, alignment: .center)
                        Text(String(format: "x%d", wave.goldenIkuraPopNum))
                            .foregroundColor(Color.black.opacity(0.6))
                            .font(systemName: .Splatfont2, size: 11)
                    })
                    Text(bundle: .CoopHistory_Available)
                        .foregroundColor(Color.black.opacity(0.6))
                        .font(systemName: .Splatfont2, size: 9)
                        .padding(.bottom, 5)
                })
            })
        })
        .aspectRatio(105/135, contentMode: .fit)
    }
}

private extension RealmCoopWave {
    var localizedText: LocalizedText {
        switch self.id {
        case 1:
            return LocalizedText.CoopHistory_Wave1
        case 2:
            return LocalizedText.CoopHistory_Wave2
        case 3:
            return LocalizedText.CoopHistory_Wave3
        default:
            return LocalizedText.CoopHistory_ExWave
        }
    }
}

private extension RealmSwift.List where Element == RealmCoopWave {
    func corner(of target: RealmCoopWave) -> UIRectCorner {
        self.firstIndex(of: target) == 0 ? [.topLeft, .bottomLeft] : self.firstIndex(of: target) == self.count - 1 ? [.topRight, .bottomRight] : []
    }
}

struct CoopWave_Previews: PreviewProvider {
    static let result: RealmCoopResult = RealmCoopResult(dummy: true)

    static var previews: some View {
        ResultWaves(result: result)
            .environment(\.resultStyle, .SPLATNET2)
            .previewLayout(.fixed(width: 600, height: 200))
        ResultWaves(result: result)
            .environment(\.resultStyle, .SPLATNET3)
            .previewLayout(.fixed(width: 600, height: 200))
    }
}
