//
//  ResultHeader.swift
//  Salmonia3+
//
//  Created by devonly on 2022/09/16.
//

import SwiftUI
import RealmSwift
import SplatNet3

struct ResultHeader: View {
    let result: RealmCoopResult

    var body: some View {
        ZStack(content: {
            Image(bundle: result.schedule.stageId)
                .resizable()
                .scaledToFill()
            HStack(content: {
                ForEach(result.schedule.weaponList, id: \.self) { weaponType in
                    Image(bundle: weaponType)
                }
                Text(String(format: "%3.2f%%", result.dangerRate * 100))
                    .font(systemName: .Splatfont, size: 16)
            })
            .padding(.horizontal)
            .background(RoundedRectangle(cornerRadius: 20).fill(Color.accentColor))
        })
    }
}

struct ResultHeader_Previews: PreviewProvider {
    static let result: RealmCoopResult = RealmCoopResult(dummy: true)
    static var previews: some View {
        ResultHeader(result: result)
            .previewLayout(.fixed(width: 400, height: 75))
            .preferredColorScheme(.dark)
    }
}
