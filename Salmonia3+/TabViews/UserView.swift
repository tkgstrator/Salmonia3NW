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
    let device: UIUserInterfaceIdiom = UIDevice.current.userInterfaceIdiom

    var body: some View {
        NavigationView(content: {
            ScrollView(content: {
                GeometryReader(content: { geometry in
                    LazyVGrid(columns: Array(repeating: .init(.flexible(minimum: 40)), count: device == .pad ? 5 : 3), spacing: 16, content: {
                        ForEach(IconType.allCases, id: \.rawValue) { iconType in
                            switch iconType {
                            case .Trash:
                                IconButton(icon: iconType, execute: {
                                    RealmService.shared.deleteAll()
                                })
                                .frame(maxWidth: 84)
                            case .Theme:
                                IconView(icon: iconType, destination: {
                                    EmptyView()
                                })
                                .frame(maxWidth: 84)
                            case .Review:
                                IconView(icon: iconType, destination: {
                                    EmptyView()
                                })
                                .frame(maxWidth: 84)
                            case .Gear:
                                IconView(icon: iconType, destination: {
                                    EmptyView()
                                })
                                .frame(maxWidth: 84)
                            }
                        }
                    })
                })
            })
            .navigationTitle("ユーザー")
            .navigationBarTitleDisplayMode(.inline)
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
