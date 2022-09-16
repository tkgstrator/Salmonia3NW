//
//  UserView.swift
//  salmonia3nw
//
//  Created by devonly on 2022/08/25.
//

import SwiftUI
import SplatNet3
import RealmSwift

struct UserView: View {
    @State private var isPresented: Bool = false
    @ObservedResults(RealmCoopResult.self) var results
    private let session: Session = Session()

    var body: some View {
        NavigationView(content: {
            Form(content: {
                Section(content: {
                    Button(action: {
                        isPresented.toggle()
                    }, label: {
                        Text("ログイン")
                    })
                    .authorize(isPresented: $isPresented, session: session)
                }, header: {
                    Text("イカリング3")
                })
                Section(content: {
                    Button(action: {
                        Task {
                            do {
                                try await session.getCoopResults()
                            } catch (let error) {
                                print(error)
                            }
                        }
                    }, label: {
                        Text("リザルト取得")
                    })
                    LabeledContent(title: "リザルト件数", value: "\(results.count)")
                }, header: {
                    Text("デバッグ")
                })
            })
            .navigationTitle("ユーザー")
            List(content: {
                ForEach(results) { result in
                    Text(result.id)
                }
            })
            .navigationTitle("リザルト")
        })
        .navigationViewStyle(.split)
    }
}

class Session: SplatNet3 {
    override func getCoopResults() async throws -> [SplatNet2.Result] {
        let summary: CoopSummary.Response = try await getCoopSummary()
        let ids: [String] = summary.data.coopResult.historyGroups.nodes.flatMap({ node in node.historyDetails.nodes.map({ $0.id }) })
        let results: [SplatNet2.Result] = try await ids.asyncMap({ try await getCoopResult(id: $0) })
        return results
    }

    override func getCoopResult(id: String) async throws -> SplatNet2.Result {
        print("Get Result", id)
        let result: SplatNet2.Result =  try await super.getCoopResult(id: id)
        dump(result)
        DispatchQueue.main.async(execute: {
            RealmService.shared.save(RealmCoopResult(from: result))
        })
        return result
    }
}


struct LabeledContent: View {
    let title: String
    let value: String

    var body: some View {
        HStack(content: {
            Text(title)
            Spacer()
            Text(value)
        })
    }
}

struct UserView_Previews: PreviewProvider {
    static var previews: some View {
        UserView()
    }
}
