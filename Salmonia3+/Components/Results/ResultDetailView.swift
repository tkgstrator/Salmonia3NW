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
                ResultDetailView(result: result, schedule: result.schedule)
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

struct ResultDetailView: View {
    let result: RealmCoopResult
    let schedule: RealmCoopSchedule
    let maxWidth: CGFloat = 340

    func refresh(sender: UIRefreshControl) {
        sender.endRefreshing()
    }

    var body: some View {
        ScrollView(showsIndicators: false, content: {
            VStack(content: {
                ResultHeader(result: result)
                    .scaledToFill()
                ResultScore(result: result)
                    .padding(.horizontal, 8)
                    .padding(.bottom, 10)
                    .frame(maxWidth: maxWidth + 60)
                LazyVGrid(
                    columns: Array(repeating: .init(.flexible(maximum: 120), spacing: 2, alignment: .top), count: result.waves.count),
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
                                .frame(maxWidth: maxWidth)
                        }
                    })
                .padding(.horizontal)
                ResultSakelien(result: result)
                    .padding(.horizontal)
            })
        })
        .background(Image("BackgroundType/SplatNet3", bundle: .main)
            .resizable(resizingMode: .tile)
            .overlay(Color.black.opacity(0.3)))
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
