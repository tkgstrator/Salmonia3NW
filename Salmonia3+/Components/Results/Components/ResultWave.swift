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
                Text(bundle: .CoopHistory_Wave1)
                    .font(systemName: .Splatfont2, size: 17)
                    .foregroundColor(.black)
                    .padding(.bottom, 3)
                ZStack(alignment: .center, content: {
                    Rectangle().fill(SPColor.SplatNet2.SPBackground)
                        .frame(height: 36.5)
                    if let goldenIkuraNum: Int = wave.goldenIkuraNum, let quotaNum: Int = wave.quotaNum {
                        Text(String(format: "%d/%d", goldenIkuraNum, quotaNum))
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
        let color: Color = isClear ? SPColor.SplatNet3.SPSalmonGreen : SPColor.SplatNet3.SPSalmonOrange
        let localizedText: LocalizedText = isClear ? .CoopHistory_Gj : .CoopHistory_Ng

        Text(bundle: localizedText)
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
                Text(bundle: .CoopHistory_Wave1)
                    .font(systemName: .Splatfont2, size: 13)
                    .foregroundColor(.black)
                    .padding(.top, 7)
                    .padding(.bottom, 4)
                ZStack(alignment: .center, content: {
                    Rectangle().fill(Color.black.opacity(0.8))
                        .frame(height: 25)
                    if let goldenIkuraNum: Int = wave.goldenIkuraNum, let quotaNum: Int = wave.quotaNum {
                        Text(String(format: "%d/%d", goldenIkuraNum, quotaNum))
                            .font(systemName: .Splatfont2, size: 17)
                    }
                })
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
                .padding(.vertical, 10)
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

struct CoopWave_Previews: PreviewProvider {
    static var previews: some View {
        LazyVGrid(columns: Array(repeating: .init(.flexible(maximum: 105), spacing: 1), count: 4), content: {
            ResultWaveSplatNet3(wave: RealmCoopWave(dummy: true, id: 1, eventType: EventType.Goldie_Seeking, waterLevel: .High_Tide))
            ResultWaveSplatNet3(wave: RealmCoopWave(dummy: true, id: 2, eventType: EventType.Goldie_Seeking, waterLevel: .Middle_Tide))
            ResultWaveSplatNet3(wave: RealmCoopWave(dummy: true, id: 3, eventType: EventType.Goldie_Seeking, waterLevel: .Low_Tide))
            ResultWaveSplatNet3(wave: RealmCoopWave(dummy: true, id: 4, eventType: EventType.Goldie_Seeking, waterLevel: .Low_Tide))
        })
        .previewLayout(.fixed(width: 600, height: 250))
        .preferredColorScheme(.dark)
        LazyVGrid(columns: Array(repeating: .init(.flexible(maximum: 123.99), spacing: 8), count: 4), content: {
            ResultWave(wave: RealmCoopWave(dummy: true, id: 1, eventType: EventType.Goldie_Seeking, waterLevel: .High_Tide))
            ResultWave(wave: RealmCoopWave(dummy: true, id: 2, eventType: EventType.Goldie_Seeking, waterLevel: .Middle_Tide))
            ResultWave(wave: RealmCoopWave(dummy: true, id: 3, eventType: EventType.Goldie_Seeking, waterLevel: .Low_Tide))
            ResultWave(wave: RealmCoopWave(dummy: true, id: 4, eventType: EventType.Goldie_Seeking, waterLevel: .Low_Tide))
        })
        .previewLayout(.fixed(width: 600, height: 250))
        .preferredColorScheme(.dark)
    }
}
