//
//  ContentView.swift
//  salmonia3nw
//
//  Created by devonly on 2022/08/25.
//

import SwiftUI
import SplatNet3
import RealmSwift

struct ContentView: View {
    /// 初回起動フラグ
    @Environment(\.isFirstLaunch) var isFirstLaunch
    /// モーダル表示かどうかのフラグ
    @Environment(\.isModalPresented) var isModalPresented
    /// 現在の表示中タブ取得
    @State private var selection: Int = 0

    var body: some View {
        TabView(selection: $selection, content: {
            ResultsWithScheduleView()
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
                .withGoogleMobileAds()
                .tabItem {
                    Label("TAB_USER".sha256Hash, image: "TabType/Me")
                }
                .tag(3)
        })
        .accentColor(.orange)
        .tabViewStyle(.automatic)
        .fullScreenCover(isPresented: isFirstLaunch , content: {
            // チュートリアル
            TutorialView()
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
