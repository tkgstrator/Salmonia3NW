//
//  ChartView.swift
//  Salmonia3+
//
//  Created by devonly on 2022/10/30.
//

import SwiftUI

/// チャートにジャンプできるView
struct ChartView<Content: View, Destination: View>: View {
    @State private var isPresented: Bool = false
    let destination: () -> Destination
    let content: () -> Content

    init(
        destination: @escaping (() -> Destination),
        content: @escaping (() -> Content)
    ) {
        self.content = content
        self.destination = destination
    }

    var body: some View {
        Button(action: {
            isPresented.toggle()
        }, label: {
            content()
        })
        .fullScreen(isPresented: $isPresented, transitionStyle: .crossDissolve, backgroundColor: .clear, content: {
            destination()
        })
    }
}
