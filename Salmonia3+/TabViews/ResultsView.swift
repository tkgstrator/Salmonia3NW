//
//  ResultsView.swift
//  Salmonia3+
//
//  Created by devonly on 2022/09/16.
//

import SwiftUI
import RealmSwift
import SplatNet3

struct ResultsView: View {
    let results: RealmSwift.Results<RealmCoopResult>
    @State private var selection: SplatNet2.Rule = SplatNet2.Rule.REGULAR

    init(results: RealmSwift.List<RealmCoopResult>) {
        self.results = results.sorted(byKeyPath: "playTime", ascending: false)
    }

    var body: some View {
        List(content: {
            ForEach(results) { result in
                NavigationLinker(destination: {
                    ResultDetailView(result: result, schedule: result.schedule)
                }, label: {
                    ResultView(result: result)
                })
            }
        })
        .listStyle(.plain)
        .navigationTitle(Text(localizedText: "TAB_RESULTS"))
        .navigationBarTitleDisplayMode(.inline)
    }
}

/// リザルトがなにもないときに下スワイプで取得できることを表示する
private struct ResultsEmpty: View {
    @State private var value: CGFloat = 0

    var body: some View {
        GeometryReader(content: { geometry in
            Text("↓")
                .font(systemName: .Splatfont, size: 34)
                .position(x: geometry.center.x, y: 80 + value)
            Text(localizedText: "PULL_TO_REFRESH")
                .font(systemName: .Splatfont, size: 28)
                .position(x: geometry.center.x, y: 180)
        })
        .onAppear(perform: {
            withAnimation(.easeInOut(duration: 0.5).repeatForever()) {
                value = 50
            }
        })
    }
}

struct ResultsWithScheduleView: View {
    @ObservedResults(
        RealmCoopResult.self,
        filter: NSPredicate(format: "rule = %@", SplatNet2.Rule.REGULAR.rawValue),
        sortDescriptor: SortDescriptor(keyPath: "playTime", ascending: false)
    ) var results
    @State private var selection: SplatNet2.Rule = SplatNet2.Rule.REGULAR
    @StateObject var session: Session = Session()

    var body: some View {
        NavigationView(content: {
            List(content: {
                TypePicker<SplatNet2.Rule>(selection: $selection)
                ForEach(results) { result in
                    NavigationLinker(destination: {
                        ResultDetailView(result: result, schedule: result.schedule)
                    }, label: {
                        ResultView(result: result)
                    })
                }
            })
            .overlay(results.isEmpty ? AnyView(ResultsEmpty()) : AnyView(EmptyView()), alignment: .center)
            .onChange(of: selection, perform: { newValue in
                $results.filter = NSPredicate(format: "rule = %@", selection.rawValue)
            })
            .refreshable(action: {
//                await session.dummy(action: {
//                })
            })
            .listStyle(.plain)
            .navigationTitle(Text(localizedText: "TAB_RESULTS"))
            .navigationBarTitleDisplayMode(.inline)
        })
        .navigationViewStyle(.split)
    }
}

extension SplatNet2.Rule: AllCaseable {}

//struct ResultsView_Previews: PreviewProvider {
//    static var previews: some View {
//        ResultsView()
//    }
//}
