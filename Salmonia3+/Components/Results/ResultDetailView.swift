//
//  ResultDetailView.swift
//  Salmonia3+
//
//  Created by devonly on 2022/09/16.
//

import SwiftUI
import SplatNet3

struct ResultDetailView: View {
    @State private var isNameVisible: Bool = true
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
                                .environment(\.isNameVisible, isNameVisible)
                        }
                    })
                ResultSakelien(result: result)
            })
        })
        .toolbar(content: {
            ToolbarItem(placement: .navigationBarTrailing, content: {
                Button(action: {
                    isNameVisible.toggle()
                }, label: {
                    Image(systemName: isNameVisible ? "eye" : "eye.slash")
                        .resizable()
                        .scaledToFit()
                        .font(Font.system(size: 30, weight: .bold))
                        .frame(width: 30, height: 30, alignment: .center)
                        .foregroundColor(SPColor.Theme.SPOrange)
                })
            })
        })
        .navigationTitle(Text(localizedText: "TAB_SCHEDULE"))
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
