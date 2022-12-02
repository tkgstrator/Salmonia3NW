//
//  ContentView.swift
//  Salmonia3+
//
//  Created by devonly on 2022/11/22.
//

import SwiftUI
import SplatNet3

struct ContentView: View {
    @State private var selection: Int = 0

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
                }
            )
            .tag(0)
            TabContent(
                bundle: .CoopHistory_History,
                icon: {
                    Image(icon: .Home)
                },
                content: {
                    EmptyView()
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
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
