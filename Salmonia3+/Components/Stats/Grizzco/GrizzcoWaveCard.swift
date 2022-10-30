//
//  GrizzcoWaveCard.swift
//  Salmonia3+
//
//  Created by devonly on 2022/10/21.
//

import SwiftUI
import SplatNet3

struct GrizzcoWaveCard: View {
    @Environment(\.colorScheme) var colorScheme: ColorScheme
    let waves: [Grizzco.WaveData]

    init(waves: [Grizzco.WaveData]) {
        self.waves = waves
    }

    var body: some View {
        NavigationLink(destination: {
            WaveChartView(waves: waves)
        }, label: {
            ZStack(alignment: .center, content: {
                SPColor.SplatNet2.SPRed
                VStack(alignment: .center, spacing: 0, content: {
                    HStack(alignment: .center, spacing: nil, content: {
                        Text(bundle: .CoopHistory_HighestScore)
                        Text(bundle: .History_Summary)
                    })
                    .font(systemName: .Splatfont2, size: 13)
                    .foregroundColor(.white)
                    .shadow(color: Color.black, radius: 0, x: 1, y: 1)
                    Spacer()
                    Text("タップで詳細を表示")
                    .font(systemName: .Splatfont, size: 16)
                    .foregroundColor(.white)
                    .shadow(color: Color.black, radius: 0, x: 1, y: 1)
                    Image(bundle: ButtonType.Squid)
                        .resizable()
                        .scaledToFit()
                        .frame(width: 30, height: 30, alignment: .center)
                })
                .padding(.top, 27)
                .padding(.bottom, 15)
                .padding(.horizontal)
            })
            .frame(width: 300, height: 160, alignment: .center)
            .mask(Image(bundle: .Card).resizable().scaledToFill())
            .clipShape(RoundedRectangle(cornerRadius: 20))
        })
    }
}

struct GrizzcoWaveCard_Previews: PreviewProvider {
    static var previews: some View {
        GrizzcoWaveCard(waves: [])
    }
}
