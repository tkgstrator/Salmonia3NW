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
            WeaponsView()
                .badge(WeaponType.allCases.count)
                .tabItem {
                    Label("Weapons", systemImage: "sparkles")
                }
            SchedulesView()
                .badge("?")
                .tabItem {
                    Label("Schedules", systemImage: "calendar")
                }
            UserView()
                .badge("New")
                .tabItem {
                    Label("Me", image: "Tabs/Me")
                }
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
