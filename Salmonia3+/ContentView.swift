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

    var body: some View {
        TabView(selection: $selection, content: {
            NavigationView(content: {
                ResultsView()
            })
            .navigationViewStyle(.split)
            .navigationBarBackButtonHidden()
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
            .navigationBarBackButtonHidden()
            .withGoogleMobileAds()
            .tabItem {
                Label(title: {
                    Text(bundle: .StageSchedule_Title)
                }, icon: {
                    Image(systemName: "calendar")
                })
            }
            .tag(1)
//            NavigationView(content: {
//                RecordsView()
//            })
//            .navigationViewStyle(.split)
//            .navigationBarBackButtonHidden()
//            .withGoogleMobileAds()
//            .tabItem {
//                Label(title: {
//                    Text(bundle: .Record_Title)
//                }, icon: {
//                    Image(systemName: "exclamationmark.circle")
//                })
//            }
//            .tag(2)
            NavigationView(content: {
                UserView()
            })
            .navigationViewStyle(.split)
            .navigationBarBackButtonHidden()
            .withGoogleMobileAds()
            .tabItem {
                Label(title: {
                    Text(bundle: .Common_Home)
                }, icon: {
                    Image(bundle: .Home)
                        .renderingMode(.template)
                })
            }
            .tag(3)
        })
        .fullScreenCover(isPresented: Binding(get: {
            session.accounts.isEmpty || isFirstLaunch
        }, set: { _ in
        }) , content: {
            TutorialView()
        })
        .accentColor(SPColor.SplatNet2.SPOrange)
        .tabViewStyle(.automatic)
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
