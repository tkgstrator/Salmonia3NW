//
//  ContentView.swift
//  salmonia3nw
//
//  Created by devonly on 2022/08/25.
//

import SwiftUI
import SplatNet3

struct ContentView: View {
    @State private var selection: Int = 0

    var body: some View {
        TabView(selection: $selection, content: {
            ResultsView()
                .badge(50)
                .tabItem {
                    Label("Results", systemImage: "sparkles")
                }
                .tag(0)
            WeaponsView()
                .badge(WeaponType.allCases.count)
                .tabItem {
                    Label("Weapons", systemImage: "sparkles")
                }
                .tag(1)
            SchedulesView()
                .badge("?")
                .tabItem {
                    Label("Schedules", systemImage: "calendar")
                }
                .tag(2)
            UserView()
                .badge("New")
                .tabItem {
                    Label("Me", image: "Tabs/Me")
                }
                .tag(3)
        })
        .accentColor(.orange)
        .tabViewStyle(.automatic)
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
