//
//  ResultSakelien.swift
//  Salmonia3+
//
//  Created by tkgstrator on 2022/09/17.
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
        LazyVGrid(
            columns: Array(repeating: .init(.flexible()), count: 1),
            spacing: 4,
            content: {
                ForEach(SakelienType.allCases.indices, id: \.self) { index in
                    let sakelien: SakelienType = SakelienType.allCases[index]
                    if bossCounts[index][2] != 0 {
                        HStack(alignment: .center, spacing: 0, content: {
                            HStack(alignment: .center, spacing: 0, content: {
                                Image(bundle: sakelien)
                                    .resizable()
                                    .scaledToFit()
                                    .frame(width: 45, height: 45, alignment: .center)
                                    .padding(.trailing, 5)
                                Text(sakelien.localizedText)
                            })
                            .frame(maxWidth: 240, alignment: .leading)
                            .padding(.trailing, 10)
                            HStack(alignment: .bottom, spacing: 0, content: {
                                Text(String(format: "%02d", bossCounts[index][0]))
                                    .frame(minWidth: 24, alignment: .leading)
                                Text(String(format: "(%02d)", bossCounts[index][1]))
                                    .frame(minWidth: 26, alignment: .leading)
                                    .font(systemName: .Splatfont2, size: 11)
                                Text("/")
                                    .padding(.horizontal, 5)
                                Text(String(format: "x%02d", bossCounts[index][2]))
                                    .frame(minWidth: 32, alignment: .trailing)
                            })
                        })
                    }
                }
                .foregroundColor(Color.white)
                .font(systemName: .Splatfont2, size: 15)
            })
        .padding(.horizontal, 15.2)
        .padding(.vertical, 10)
        .background(RoundedRectangle(cornerRadius: 10).fill(Color.black.opacity(0.4)))
        .frame(maxWidth: 380)
        .padding(.horizontal, 10)
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
