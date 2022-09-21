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
import StoreKit

struct UserView: View {
    @ObservedResults(RealmCoopResult.self, sortDescriptor: SortDescriptor(keyPath: "playTime", ascending: false)) var results
    @StateObject var session: Session = Session()
    @State private var isPresented: Bool = false
    @AppStorage("IS_FIRST_LAUNCH") var isFirstLaunch: Bool = true
    @AppStorage("PREFERRED_COLOR_SCHEME") var preferredColorScheme: Bool = true
//    let device: UIUserInterfaceIdiom = UIDevice.current.userInterfaceIdiom

    var body: some View {
        NavigationView(content: {
            ScrollView(content: {
                GeometryReader(content: { geometry in
                    LazyVGrid(columns: Array(repeating: .init(.flexible(minimum: 40)), count: 3), spacing: 16, content: {
                        ForEach(IconType.allCases, id: \.rawValue) { iconType in
                            switch iconType {
                            case .Trash:
                                IconView(icon: iconType, destination: {
                                    DeleteConfirmView()
                                })
                                .frame(maxWidth: 84)
                            case .Theme:
                                IconButton(icon: iconType, execute: {
                                    preferredColorScheme.toggle()
                                })
                                .frame(maxWidth: 84)
                            case .Review:
                                IconButton(icon: iconType, execute: {
                                    if let scene = UIApplication.shared.connectedScenes.first as? UIWindowScene {
                                        SKStoreReviewController.requestReview(in: scene)
                                    }
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
            .navigationTitle(Text(localizedText: "TAB_USER"))
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
            .previewLayout(.fixed(width: 400, height: 300))
        UserView()
            .previewLayout(.fixed(width: 400, height: 300))
            .preferredColorScheme(.dark)
    }
}
