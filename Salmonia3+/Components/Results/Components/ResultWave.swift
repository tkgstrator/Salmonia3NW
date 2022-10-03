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
        GeometryReader(content: { geometry in
            let scale: CGFloat = geometry.width / 124
            ZStack(content: {
                RoundedRectangle(cornerRadius: 3).fill(SPColor.Theme.SPYellow)
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
                        Rectangle().fill(SPColor.Theme.SPDark)
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
