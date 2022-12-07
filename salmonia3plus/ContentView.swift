//
//  ContentView.swift
//  Salmonia3+
//
//  Created by devonly on 2022/11/22.
//

import SwiftUI
import SplatNet3

struct ContentView: View {
    @EnvironmentObject var session: Session
    @State private var selection: Int = 2
    @State private var isPresented: Bool = false

    public func TabContent<Content: View>(
        bundle: LocalizedType,
        icon: @escaping () -> Image,
        content: @escaping () -> Content
    ) -> some View {
        NavigationView(content: {
            content()
                .navigationTitle(Text(bundle: bundle))
                .navigationBarTitleDisplayMode(.inline)
        })
        .navigationViewStyle(.split)
        .tabItem({
            Label(title: {
                Text(bundle: bundle)
            }, icon: {
                icon()
            })
        })
    }

    var body: some View {
        TabView(selection: $selection, content: {
            TabContent(
                bundle: .CoopHistory_History,
                icon: {
                    Image(icon: .Home)
                },
                content: {
                    ResultsView()
                        .environment(\.isModalPresented, $isPresented)
                }
            )
            .tag(0)
            TabContent(
                bundle: .StageSchedule_Title,
                icon: {
                    Image(icon: .Home)
                },
                content: {
                    SchedulesView()
                        .environment(\.isModalPresented, $isPresented)
                }
            )
            .tag(1)
            TabContent(
                bundle: .Common_MyPage,
                icon: {
                    Image(icon: .Me)
                },
                content: {
                    MyPageView()
                }
            )
            .tag(2)
        })
        .fullScreen(isPresented: $isPresented, session: session)
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
