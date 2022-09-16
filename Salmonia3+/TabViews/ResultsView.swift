//
//  ResultsView.swift
//  Salmonia3+
//
//  Created by devonly on 2022/09/16.
//

import SwiftUI
import RealmSwift

struct ResultsView: View {
    @ObservedResults(RealmCoopResult.self, sortDescriptor: SortDescriptor(keyPath: "playTime", ascending: false)) var results

    var body: some View {
        NavigationView(content: {
            List(content: {
                ForEach(results) { result in
                    NavigationLink(destination: ResultDetailView(result: result, schedule: result.schedule), label: {
                        ResultView(result: result)
                    })
                }
            })
            .listStyle(.plain)
            .navigationTitle("リザルト")
        })
        .navigationViewStyle(.split)
    }
}

struct ResultsView_Previews: PreviewProvider {
    static var previews: some View {
        ResultsView()
    }
}
