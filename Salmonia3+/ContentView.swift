//
//  ContentView.swift
//  salmonia3nw
//
//  Created by tkgstrator on 2022/08/25.
//

import SwiftUI
import SplatNet3
import RealmSwift

struct ContentView: View {
    @AppStorage("CONFIG_IS_FIRST_LAUNCH") var isFirstLaunch: Bool = true
    @StateObject var session: Session = Session()
    /// 現在の表示中タブ取得
    @State private var selection: Int = 0
    @State private var isLaunchAsAppStore: Bool = VersionUpdater.launchAsTestFlight() == .AppStore

    private func Results() -> some View {
        NavigationView(content: {
            ResultsView()
        })
        .navigationViewStyle(.split)
        .navigationBarBackButtonHidden()
        .withGoogleMobileAds(enabled: isLaunchAsAppStore)
        .tabItem {
            Label(title: {
                Text(bundle: .CoopHistory_History)
            }, icon: {
                Image(systemName: "sparkles")
            })
        }
        .tag(0)
    }

    private func Schedules() -> some View {
        NavigationView(content: {
            SchedulesView()
        })
        .navigationViewStyle(.split)
        .navigationBarBackButtonHidden()
        .withGoogleMobileAds(enabled: isLaunchAsAppStore)
        .tabItem {
            Label(title: {
                Text(bundle: .StageSchedule_Title)
            }, icon: {
                Image(systemName: "calendar")
            })
        }
        .tag(1)
    }

    private func Home() -> some View {
        NavigationView(content: {
            UserView()
        })
        .navigationViewStyle(.split)
        .navigationBarBackButtonHidden()
        .withGoogleMobileAds(enabled: isLaunchAsAppStore)
        .tabItem {
            Label(title: {
                Text(bundle: .Common_MyPage)
            }, icon: {
                Image(bundle: .Home)
                    .renderingMode(.template)
            })
        }
        .tag(3)
    }

    var body: some View {
        TabView(selection: $selection, content: {
            Results()
            Schedules()
            Home()
        })
        .fullScreenCover(isPresented: $isFirstLaunch, content: {
            TutorialView()
        })
        .accentColor(SPColor.SplatNet2.SPOrange)
        .tabViewStyle(.automatic)
    }
}

struct GoogleMobileAds: ViewModifier {
    func body(content: Content) -> some View {
        content
            .padding(.bottom, 50)
            .overlay(GoogleMobileAdsView(), alignment: .bottom)
    }
}

extension View {
    func withGoogleMobileAds(enabled: Bool) -> some View {
        enabled ? AnyView(self.modifier(GoogleMobileAds())) : AnyView(self)
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
