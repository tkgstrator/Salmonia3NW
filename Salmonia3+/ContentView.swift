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
    /// タブを戻すための処理
    @State private var root: [UUID] = [UUID(), UUID(), UUID()]

    /// 切り替え用の変数
    private var selected: Binding<Int> {
        Binding(
            get: {
                return selection
            },
            set: { newValue in
                if newValue == selection {
                    root[selection] = UUID()
                }
                selection = newValue
            })
    }

    var body: some View {
        TabView(selection: selected, content: {
            NavigationView(content: {
                ResultsWithScheduleView()
                    .id(root[0])
            })
            .navigationViewStyle(.split)
            .withGoogleMobileAds()
            .tabItem {
                Label("TAB_RESULTS".sha256Hash, systemImage: "sparkles")
            }
            .tag(0)
            NavigationView(content: {
                SchedulesView()
                    .id(root[1])
            })
            .navigationViewStyle(.split)
            .withGoogleMobileAds()
            .tabItem {
                Label("TAB_SCHEDULE".sha256Hash, systemImage: "calendar")
            }
            .tag(1)
            NavigationView(content: {
                UserView()
                    .id(root[2])
            })
            .navigationViewStyle(.split)
            .withGoogleMobileAds()
            .tabItem {
                Label("TAB_USER".sha256Hash, image: "TabType/Me")
            }
            .tag(2)
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
