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
    @AppStorage("IS_FIRST_LAUNCH") var isFirstLaunch: Bool = true
    @State private var selection: Int = 0

    var body: some View {
        TabView(selection: $selection, content: {
            ResultsWithScheduleView()
                .withGoogleMobileAds()
                .badge(50)
                .tabItem {
                    Label("Results", systemImage: "sparkles")
                }
                .tag(0)
            SchedulesView()
                .withGoogleMobileAds()
                .badge("?")
                .tabItem {
                    Label("Schedules", systemImage: "calendar")
                }
                .tag(2)
            UserView()
                .withGoogleMobileAds()
                .badge("New")
                .tabItem {
                    Label("Me", image: "Tabs/Me")
                }
                .tag(3)
        })
        .accentColor(.orange)
        .tabViewStyle(.automatic)
        .fullScreenCover(isPresented: $isFirstLaunch, content: {
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
