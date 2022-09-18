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
import SDWebImageSwiftUI

struct UserView: View {
    @ObservedResults(RealmCoopResult.self, sortDescriptor: SortDescriptor(keyPath: "playTime", ascending: false)) var results
    @StateObject var session: Session = Session()
    @State private var isPresented: Bool = false
    @AppStorage("IS_FIRST_LAUNCH") var isFirstLaunch: Bool = true

    var body: some View {
        NavigationView(content: {
            LazyVGrid(columns: Array(repeating: .init(.flexible(minimum: 40, maximum: 60)), count: 3), content: {
                Button(action: {
                    isFirstLaunch.toggle()
                }, label: {
                    Text("Sign out")
                })
            })
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
