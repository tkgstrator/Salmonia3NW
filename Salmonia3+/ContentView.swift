//
//  ContentView.swift
//  salmonia3nw
//
//  Created by devonly on 2022/08/25.
//

import SwiftUI
import SplatNet3
import RealmSwift
import PopupView

struct ContentView: View {
    @StateObject var session: Session = Session()
    /// 初回起動フラグ
    @Environment(\.isFirstLaunch) var isFirstLaunch
    /// 認証中フラグ
    @Environment(\.isOAuthPresented) var isOAuthPresented
    /// リザルト取得中フラグ
    @State private var isModalPopuped: Bool = false
    /// 現在の表示中タブ取得
    @State private var selection: Int = 0

    var body: some View {
        TabView(selection: $selection, content: {
            ResultsWithScheduleView()
                .environment(\.isModalPopuped, $isModalPopuped)
                .withGoogleMobileAds()
                .tabItem {
                    Label("TAB_RESULTS".sha256Hash, systemImage: "sparkles")
                }
                .tag(0)
            SchedulesView()
                .withGoogleMobileAds()
                .tabItem {
                    Label("TAB_SCHEDULE".sha256Hash, systemImage: "calendar")
                }
                .tag(2)
            UserView()
                .environment(\.isModalPopuped, $isModalPopuped)
                .withGoogleMobileAds()
                .tabItem {
                    Label("TAB_USER".sha256Hash, image: "TabType/Me")
                }
                .tag(3)
        })
        .onAppear(perform: {
            print(isOAuthPresented)
        })
        .accentColor(.orange)
        .tabViewStyle(.automatic)
        .popup(isPresented: isOAuthPresented, view: {
            LoadingView(session: session)
        })
        .fullScreenCover(isPresented: $isModalPopuped, content: {
            // リザルト読み込み
            ResultLoadingView()
                .environment(\.isModalPopuped, $isModalPopuped)
        })
        .fullScreenCover(isPresented: isFirstLaunch , content: {
            // チュートリアル
            TutorialView()
                .environment(\.isOAuthPresented, isOAuthPresented)
        })
    }
}

struct GoogleMobileAds: ViewModifier {
    func body(content: Content) -> some View {
        VStack(alignment: .center, spacing: 0, content: {
            content
            GoogleMobileAdsView()
        })
    }
}

extension View {
    func withGoogleMobileAds() -> some View {
        self.modifier(GoogleMobileAds())
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
