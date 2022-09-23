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
    @Environment(\.isFirstLaunch) var isFirstLaunch: Binding<Bool>
    @State private var isModalPopuped: Bool = false
    @State private var selection: Int = 0

    var body: some View {
        TabView(selection: $selection, content: {
            ResultsWithScheduleView()
                .withGoogleMobileAds()
                .badge(50)
                .tabItem {
                    Label("TAB_RESULTS".sha256Hash, systemImage: "sparkles")
                }
                .tag(0)
                .environment(\.isModalPopuped, $isModalPopuped)
            SchedulesView()
                .withGoogleMobileAds()
                .badge("?")
                .tabItem {
                    Label("TAB_SCHEDULE".sha256Hash, systemImage: "calendar")
                }
                .tag(2)
            UserView()
                .withGoogleMobileAds()
                .badge("New")
                .tabItem {
                    Label("TAB_USER".sha256Hash, image: "TabType/Me")
                }
                .tag(3)
        })
        .accentColor(.orange)
        .tabViewStyle(.automatic)
        .overlay(isModalPopuped ? AnyView(Color.black.opacity(0.3).ignoresSafeArea()) : AnyView(EmptyView()))
        .popup(isPresented: $isModalPopuped, autohideIn: 60, dragToDismiss: false, closeOnTap: false, closeOnTapOutside: false, view: {
            ResultLoadingView()
                .environment(\.isModalPopuped, $isModalPopuped)
        })
        .fullScreenCover(isPresented: isFirstLaunch , content: {
            TutorialView()
                .environment(\.isModalPopuped, $isModalPopuped)
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
