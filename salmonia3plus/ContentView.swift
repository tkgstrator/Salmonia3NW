//
//  ContentView.swift
//  Salmonia3+
//
//  Created by devonly on 2022/11/22.
//

import SwiftUI
import SplatNet3

struct ContentView: View {
    @StateObject private var session: Session = Session()
    @State private var selection: Int = 0
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
                bundle: .CoopHistory_History,
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
                    Image(icon: .Home)
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
