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
    let results: RealmSwift.List<RealmCoopResult>
    @State private var selection: SplatNet2.Rule = SplatNet2.Rule.REGULAR

    var body: some View {
        List(content: {
//            TypePicker<SplatNet2.Rule>(selection: $selection)
            ForEach(results) { result in
                NavigationLinker(destination: {
                    ResultDetailView(result: result, schedule: result.schedule)
                }, label: {
                    ResultView(result: result)
                })
            }
        })
//        .onChange(of: selection, perform: { newValue in
//            $results.filter = NSPredicate(format: "rule = %@", selection.rawValue)
//        })
        .listStyle(.plain)
        .navigationTitle("リザルト")
        .navigationBarTitleDisplayMode(.inline)
    }
}

struct ResultsWithScheduleView: View {
    @ObservedResults(
        RealmCoopResult.self,
        filter: NSPredicate(format: "rule = %@", SplatNet2.Rule.REGULAR.rawValue),
        sortDescriptor: SortDescriptor(keyPath: "playTime", ascending: false)
    ) var results

    @State private var selection: SplatNet2.Rule = SplatNet2.Rule.REGULAR

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
            .onChange(of: selection, perform: { newValue in
                $results.filter = NSPredicate(format: "rule = %@", selection.rawValue)
            })
            .listStyle(.plain)
            .navigationTitle("リザルト")
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
