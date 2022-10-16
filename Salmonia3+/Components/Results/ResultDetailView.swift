//
//  ResultDetailView.swift
//  Salmonia3+
//
//  Created by devonly on 2022/09/16.
//

import SwiftUI
import SplatNet3
import RealmSwift
import Introspect

struct ResultTabView: View {
    @Environment(\.selection) var selection
    @State private var isNameVisible: Bool = true
    let results: RealmSwift.List<RealmCoopResult>

    var selected: Binding<String> {
        Binding(get: {
            selection.wrappedValue
        }, set: { newValue in
            selection.wrappedValue = newValue
        })
    }

    var body: some View {
        TabView(selection: selected, content: {
            ForEach(results.reversed()) { result in
                ResultDetailView(result: result)
                    .environment(\.isNameVisible, isNameVisible)
                    .tag(result.id)
            }
        })
        .navigationTitle(Text(bundle: .CoopHistory_History))
        .navigationBarTitleDisplayMode(.inline)
        .tabViewStyle(.page(indexDisplayMode: .never))
        .toolbar(content: {
            ToolbarItem(placement: .navigationBarTrailing, content: {
                Button(action: {
                    isNameVisible.toggle()
                }, label: {
                    Image(bundle: isNameVisible ? .Eye : .EyeSlash)
                        .resizable()
                        .scaledToFit()
                        .font(Font.system(size: 30, weight: .bold))
                        .frame(width: 30, height: 30, alignment: .center)
                        .foregroundColor(.primary)
                })
            })
        })
    }
}

private struct ResultDetailView: View {
    @State private var resultStyle: ResultStyle = .SPLATNET3
    let result: RealmCoopResult

    var body: some View {
        ScrollView(showsIndicators: false, content: {
            VStack(spacing: 0, content: {
                ResultHeader(result: result)
                ResultScore(result: result)
                ResultWaves(result: result)
                    .environment(\.resultStyle, resultStyle)
                ResultPlayers(result: result)
                    .environment(\.resultStyle, resultStyle)
                ResultSakelien(result: result)
            })
        })
        .background(ResultBackground())
    }
}

#warning("ここ、ちょっと改良したい")
private struct ResultBackground: View {
    var body: some View {
        ZStack(alignment: .top, content: {
            Color(hex: "292E35")
//                .ignoresSafeArea()
//            Color(hex: "141212")
                .ignoresSafeArea()
//                .frame(maxHeight: 540)
//            Image(bundle: BackgroundType.SPLATNET3)
//                .resizable(resizingMode: .tile)
//                .frame(maxHeight: 540)
//                .opacity(0.35)
        })
    }
}

struct ResultDetailView_Previews: PreviewProvider {
    static private let result: RealmCoopResult = RealmCoopResult(dummy: true)
    static private let schedule: RealmCoopSchedule = RealmCoopSchedule(dummy: true)

    static var previews: some View {
        ResultDetailView(result: result)
    }
}
