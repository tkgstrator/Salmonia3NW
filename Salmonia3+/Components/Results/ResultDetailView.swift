//
//  ResultDetailView.swift
//  Salmonia3+
//
//  Created by devonly on 2022/09/16.
//

import SwiftUI

struct ResultDetailView: View {
    let result: RealmCoopResult
    let schedule: RealmCoopSchedule

    var body: some View {
        ScrollView(showsIndicators: false, content: {
            VStack(content: {
                ResultHeader(result: result)
                    .scaledToFill()
                ResultScore(result: result)
                    .scaledToFill()
                    .padding(.horizontal, 4)
                    .frame(maxWidth: 540)
                LazyVGrid(
                    columns: Array(repeating: .init(.flexible(maximum: 120), spacing: nil, alignment: .top), count: result.waves.count),
                    alignment: .center,
                    spacing: 0,
                    content: {
                        ForEach(result.waves, id: \.self) { wave in
                            VStack(content: {
                                ResultWave(wave: wave)
                                ResultSpecial(result: wave)
                            })
                        }
                    })
                LazyVGrid(
                    columns: Array(repeating: .init(.flexible(), spacing: nil), count: 1),
                    alignment: .center,
                    spacing: nil,
                    content: {
                        ForEach(result.players, id: \.self) { player in
                            ResultPlayer(result: player)
                                .frame(maxWidth: 400)
                                .padding(.horizontal, 4)
                        }
                    })
                ResultSakelien(result: result)
                    .frame(maxWidth: 540)
                    .padding(.horizontal, 4)
            })
        })
        .navigationTitle("リザルト詳細")
        .navigationBarTitleDisplayMode(.inline)
    }
}

struct ResultDetailView_Previews: PreviewProvider {
    static private let result: RealmCoopResult = RealmCoopResult(dummy: true)
    static private let schedule: RealmCoopSchedule = RealmCoopSchedule(dummy: true)

    static var previews: some View {
        ResultDetailView(result: result, schedule: schedule)
            .previewLayout(.fixed(width: 390, height: 844))
    }
}
