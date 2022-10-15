//
//  CoopWave.swift
//  Salmonia3+
//
//  Created by devonly on 2022/09/17.
//

import SwiftUI
import SplatNet3

struct ResultWave: View {
    let wave: RealmCoopWave

    var body: some View {
        ResultWaveSplatNet2(wave: wave)
    }
}

private struct ResultWaveSplatNet2: View {
    let wave: RealmCoopWave

    var body: some View {
        GeometryReader(content: { geometry in
            let scale: CGFloat = geometry.width / 124
            ZStack(content: {
                RoundedRectangle(cornerRadius: 3).fill(SPColor.SplatNet2.SPYellow)
                    .mask(Hanger().scaledToFill())
                    .overlay(Image(bundle: .WAVE).resizable().scaledToFill())
                    .overlay(WaterLevel().fill(.black.opacity(0.2)).offset(x: 0, y: wave.waterLevel.height * scale).clipped())
                    .clipShape(RoundedRectangle(cornerRadius: 3))
                VStack(alignment: .center, spacing: 0, content: {
                    let waveId: LocalizedText = {
                        switch wave.id {
                        case 1:
                            return .CoopHistory_Wave1
                        case 2:
                            return .CoopHistory_Wave2
                        case 3:
                            return .CoopHistory_Wave3
                        default:
                            return .CoopHistory_ExWave
                        }
                    }()
                    Text(bundle: waveId)
                        .font(systemName: .Splatfont2, size: 17 * scale)
                        .frame(height: 25 * scale, alignment: .center)
                        .foregroundColor(.black)
                    ZStack(content: {
                        Rectangle().fill(SPColor.SplatNet2.SPBackground)
                        if let goldenIkuraNum = wave.goldenIkuraNum, let quotaNum = wave.quotaNum {
                            Text("\(goldenIkuraNum)/\(quotaNum)")
                                .font(systemName: .Splatfont2, size: 25 * scale)
                                .frame(height: 36.5 * scale, alignment: .center)
                                .foregroundColor(.white)
                        } else {
                            Text(SakelienType.SakelienGiant.localizedText)
                                .font(systemName: .Splatfont2, size: 25 * scale)
                                .frame(height: 36.5 * scale, alignment: .center)
                                .foregroundColor(.red)
                        }
                    })
                    .padding(.top, 2 * scale)
                    .frame(height: 36.5 * scale, alignment: .center)
                    Text(wave.waterLevel.localizedText)
                        .font(systemName: .Splatfont2, size: 16 * scale)
                        .foregroundColor(.black)
                        .frame(height: 16 * scale)
                        .padding(.top, 8)
                    Text(wave.eventType.localizedText)
                        .font(systemName: .Splatfont2, size: 16 * scale)
                        .foregroundColor(.black)
                        .frame(height: 16 * scale)
                        .padding(.top, 8)
                    HStack(spacing: nil, content: {
                        Image(bundle: .Golden)
                            .resizable()
                            .frame(width: 20 * scale, height: 20 * scale, alignment: .center)
                        Text("x\(wave.goldenIkuraPopNum)")
                            .font(systemName: .Splatfont2, size: 16 * scale)
                            .frame(height: 16 * scale)
                            .foregroundColor(.white)
                            .shadow(color: .black, radius: 0, x: 1, y: 1)
                    })
                    .padding(.top, 4)
                })
            })
            .overlay(Image(bundle: wave.isClearWave ? .CLEAR : .FAILURE).resizable().frame(width: 34 * scale, height: 34 * scale, alignment: .topTrailing).offset(x: 12 * scale, y: -17 * scale), alignment: .topTrailing)
        })
        .aspectRatio(124/160, contentMode: .fit)
        .padding(.top, 10)
    }
}

private struct WaveResult: View {
    let isClear: Bool

    var body: some View {
        let color: Color = isClear ? SPColor.SplatNet3.SPSalmonGreen : SPColor.SplatNet3.SPSalmonOrange
        let localizedText: LocalizedText = isClear ? .CoopHistory_Gj : .CoopHistory_Ng

        Text(bundle: localizedText)
    }
}

private struct ResultWaveSplatNet3: View {
    let wave: RealmCoopWave

    var body: some View {
        GeometryReader(content: { geometry in
            ZStack(alignment: .top, content: {
                ZStack(content: {
                    Rectangle()
                        .fill(SPColor.SplatNet3.SPYellow)
                    Rectangle()
                        .fill(Color.clear)
                        .border(.black, width: 1)
                    WaterLevel()
                        .fill(.black.opacity(0.2))
                        .offset(x: 0, y: wave.waterLevel.height)
                })
                VStack(alignment: .center, spacing: 4, content: {
                    Text(bundle: .CoopHistory_Wave1)
                        .foregroundColor(.black)
                        .font(systemName: .Splatfont2, size: 15)
                        .padding(.top, 8)
                    Group(content: {
                        if let goldenIkuraNum: Int = wave.goldenIkuraNum, let quotaNum: Int = wave.quotaNum {
                            Text(String(format: "%d/%d", goldenIkuraNum, quotaNum))
                                .foregroundColor(.white)
                        } else {
                            Text(SakelienType.SakelienGiant.localizedText)
                                .foregroundColor(.white)
                        }
                    })
                    .font(systemName: .Splatfont2, size: 18)
                    .padding(.vertical, 4)
                    .frame(maxWidth: .infinity)
                    .background(Rectangle().fill(SPColor.SplatNet3.SPBackground))
                    Text(wave.waterLevel.localizedText)
                        .foregroundColor(.black)
                        .font(systemName: .Splatfont2, size: 13)
                    Text(wave.eventType.localizedText)
                        .foregroundColor(.black)
                        .font(systemName: .Splatfont2, size: 13)
                    Label(title: {
                        Text(String(format: "x%d", wave.goldenIkuraPopNum))
                            .foregroundColor(SPColor.SplatNet3.SPBackground)
                            .font(systemName: .Splatfont2, size: 13)
                    }, icon: {
                        Image(bundle: .GoldenIkura)
                            .resizable()
                            .scaledToFit()
                            .frame(width: 24, height: 24, alignment: .center)
                    })
                })
            })
        })
        .aspectRatio(124/160, contentMode: .fit)
    }
}

private extension WaterType {
    var height: CGFloat {
        switch self {
        case .Low_Tide:
            return 130
        case .Middle_Tide:
            return 105
        case .High_Tide:
            return 80
        }
    }
}

struct CoopWave_Previews: PreviewProvider {
    static var previews: some View {
        LazyVGrid(columns: Array(repeating: .init(spacing: 0), count: 4), content: {
            ResultWaveSplatNet3(wave: RealmCoopWave(dummy: true, id: 1, eventType: EventType.Goldie_Seeking, waterLevel: .High_Tide))
            ResultWaveSplatNet3(wave: RealmCoopWave(dummy: true, id: 2, eventType: EventType.Goldie_Seeking, waterLevel: .Middle_Tide))
            ResultWaveSplatNet3(wave: RealmCoopWave(dummy: true, id: 3, eventType: EventType.Goldie_Seeking, waterLevel: .Low_Tide))
            ResultWaveSplatNet3(wave: RealmCoopWave(dummy: true, id: 4, eventType: EventType.Goldie_Seeking, waterLevel: .Low_Tide))
        })
        .clipShape(RoundedRectangle(cornerRadius: 10))
        .previewLayout(.fixed(width: 460, height: 250))
        .preferredColorScheme(.dark)
        LazyVGrid(columns: Array(repeating: .init(), count: 4), content: {
            ResultWave(wave: RealmCoopWave(dummy: true, id: 1, eventType: EventType.Goldie_Seeking, waterLevel: .High_Tide))
            ResultWave(wave: RealmCoopWave(dummy: true, id: 2, eventType: EventType.Goldie_Seeking, waterLevel: .Middle_Tide))
            ResultWave(wave: RealmCoopWave(dummy: true, id: 3, eventType: EventType.Goldie_Seeking, waterLevel: .Low_Tide))
            ResultWave(wave: RealmCoopWave(dummy: true, id: 4, eventType: EventType.Goldie_Seeking, waterLevel: .Low_Tide))
        })
        .previewLayout(.fixed(width: 460, height: 250))
        .preferredColorScheme(.dark)
    }
}
