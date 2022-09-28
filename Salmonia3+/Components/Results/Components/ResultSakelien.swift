//
//  ResultSakelien.swift
//  Salmonia3+
//
//  Created by devonly on 2022/09/17.
//

import SwiftUI
import SplatNet3

struct ResultSakelien: View {
    let bossCounts: [[Int]]

    init(result: RealmCoopResult) {
        if let bossKillCounts = result.players.first?.bossKillCounts {
            self.bossCounts = [result.bossKillCounts, bossKillCounts, result.bossCounts].transposed()
            return
        }
        self.bossCounts = Array(repeating: [99, 99, 99], count: 15)
    }

    var body: some View {
        VStack(spacing: nil, content: {
            ForEach(bossCounts.indices, id: \.self) { index in
                let bossCount: [Int] = bossCounts[index]
                let sakelienType: SakelienType = SakelienType.allCases[index]
                if bossCount[2] != 0 {
                    HStack(spacing: 20, content: {
                        Image(bundle: sakelienType)
                            .resizable()
                            .scaledToFill()
                            .frame(width: 40, height: 40, alignment: .center)
                            .padding(2)
                            .background(Circle().fill(SPColor.Theme.SPTheme))
                        Text(sakelienType.localizedText)
                            .font(systemName: .Splatfont2, size: 18)
                            .frame(height: 16, alignment: .center)
                        Spacer()
                        HStack(alignment: .lastTextBaseline, spacing: 0, content: {
                            Text(String(format: "%02d", bossCount[0]))
                                .frame(width: 30)
                            Text(String(format: "(%02d)", bossCount[1]))
                                .frame(width: 30)
                                .font(systemName: .Splatfont2, size: 14)
                            Text(String(format: "/%02d", bossCount[2]))
                                .frame(width: 40)
                        })
                        .font(systemName: .Splatfont2, size: 18)
                        .frame(height: 16, alignment: .center)
                    })
                    if index != bossCounts.count {
                        Divider()
                    }
                }
            }
        })
        .frame(maxWidth: 340)
    }
}

struct ResultSakelien_Previews: PreviewProvider {
    static let result: RealmCoopResult = RealmCoopResult()
    static var previews: some View {
        ResultSakelien(result: result)
            .previewLayout(.fixed(width: 400, height: 300))
            .preferredColorScheme(.dark)
        ResultSakelien(result: result)
            .previewLayout(.fixed(width: 400, height: 300))
    }
}
