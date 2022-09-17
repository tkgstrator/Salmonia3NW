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
    let foregroundColor: Color = Color(hex: "#2A270B")
    let backgroundColor: Color = Color(hex: "E5F100")

    var body: some View {
        GeometryReader(content: { geometry in
            let scale: CGFloat = geometry.width / 124
            VStack(alignment: .center, spacing: 0, content: {
                Text("Wave \(wave.id)")
                    .font(systemName: .Splatfont2, size: 17 * scale)
                    .frame(height: 25 * scale, alignment: .center)
                    .foregroundColor(.black)
                ZStack(content: {
                    Rectangle().fill(foregroundColor)
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
                    .font(systemName: .Splatfont2, size: 14 * scale)
                    .foregroundColor(.black)
                    .padding(.top, 8 * scale)
                Text(wave.eventType.localizedText)
                    .font(systemName: .Splatfont2, size: 14 * scale)
                    .foregroundColor(.black)
                HStack(spacing: nil, content: {
                    Image(bundle: .Golden)
                        .resizable()
                        .frame(width: 20 * scale, height: 20 * scale, alignment: .center)
                    Text("x\(wave.goldenIkuraPopNum)")
                        .font(systemName: .Splatfont2, size: 14 * scale)
                        .foregroundColor(.gray)
                })
            })
            .frame(maxWidth: .infinity)
            .padding(.vertical, 16 * scale)
            .overlay(WaterLevel().fill(Color.black.opacity(0.2)).offset(x: 0, y: wave.waterLevel.height * scale).clipped())
        })
        .background(RoundedRectangle(cornerRadius: 6).fill(backgroundColor))
        .mask(Hanger().scaledToFill())
        .aspectRatio(124/180, contentMode: .fit)
    }
}

private extension WaterType {
    var height: CGFloat {
        switch self {
        case .Low_Tide:
            return 154
        case .Middle_Tide:
            return 124
        case .High_Tide:
            return 94
        }
    }
}

struct CoopWave_Previews: PreviewProvider {
    static let wave: RealmCoopWave = RealmCoopWave(dummy: true)
    static var previews: some View {
        ResultWave(wave: wave)
            .previewLayout(.fixed(width: 400, height: 200))
            .preferredColorScheme(.dark)
    }
}
