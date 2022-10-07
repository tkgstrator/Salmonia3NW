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
            NavigationView(content: {
                ResultsWithScheduleView()
            })
            .navigationViewStyle(.split)
            .withGoogleMobileAds()
            .tabItem {
                Label(title: {
                    Text(bundle: .CoopHistory_History)
                }, icon: {
                    Image(systemName: "sparkles")
                })
            }
            .tag(0)
            NavigationView(content: {
                SchedulesView()
            })
            .navigationViewStyle(.split)
            .withGoogleMobileAds()
            .tabItem {
                Label(title: {
                    Text(bundle: .StageSchedule_Title)
                }, icon: {
                    Image(systemName: "calendar")
                })
            }
            .tag(1)
            NavigationView(content: {
                UserView()
            })
            .navigationViewStyle(.split)
            .withGoogleMobileAds()
            .tabItem {
                Label(title: {
                    Text(bundle: .Common_Home)
                }, icon: {
                    Image("TabType/Me", bundle: .main)
                })
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
