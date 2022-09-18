//
//  UserView.swift
//  salmonia3nw
//
//  Created by devonly on 2022/08/25.
//

import SwiftUI
import SplatNet3
import RealmSwift
import PopupView

struct UserView: View {
    @ObservedResults(RealmCoopResult.self, sortDescriptor: SortDescriptor(keyPath: "playTime", ascending: false)) var results
    @StateObject var session: Session = Session()
    @State private var isPresented: Bool = false

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
                    HStack(content: {
                        switch session.account {
                        case .none:
                            Text("未ログイン")
                        case .some(_):
                            Text("ログイン済")
                        }
                    })
                }, header: {
                    Text("イカリング3")
                }, footer: {
                    Text("テスト版のためログイン後再起動が必要になります、多分")
                })
            })
            .navigationTitle("ユーザー")
            List(content: {
                ForEach(results) { result in
                    ResultView(result: result)
                }
            })
            .listStyle(.plain)
            .navigationTitle("リザルト")
        })
        .navigationViewStyle(.split)
        .popup(isPresented: $session.isPopuped, view: {
            LoadingView(session: session)
        })
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
