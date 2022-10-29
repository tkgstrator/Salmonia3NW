//
//  ResultRefreshable.swift
//  Salmonia3+
//
//  Created by devonly on 2022/10/19.
//

import SwiftUI
import Introspect
import MapKit

private struct ResultRefreshable: ViewModifier {
    @StateObject private var session: Session = Session()
    @State private var isPresented: Bool = false

    func body(content: Content) -> some View {
        content
            .refreshable(action: {
                await session.dummy(action: {
                    isPresented.toggle()
                })
            })
            .fullScreen(isPresented: $isPresented, content: {
                ResultLoadingView()
                    .environment(\.isModalPresented, $isPresented)
            })
    }
}

private struct ResultRefreshableScroll: ViewModifier {
    @StateObject private var session: Session = Session()
    @State private var isPresented: Bool = false

    func body(content: Content) -> some View {
        content
            .refreshableScroll(action: {
                await session.dummy(action: {
                    isPresented.toggle()
                })
            })
            .fullScreen(isPresented: $isPresented, content: {
                ResultLoadingView()
                    .environment(\.isModalPresented, $isPresented)
            })
    }
}

extension View {
    func refreshableResult() -> some View {
        self.modifier(ResultRefreshable())
    }

    func refreshableResultScroll() -> some View {
        self.modifier(ResultRefreshableScroll())
    }
}

extension View {
    /// Marks ScrollView as refreshable.
    func refreshableScroll(action: @escaping () async -> Void) -> some View {
        self.introspectScrollView(customize: { uiScrollView in
            let refreshControl: UIRefreshControl = UIRefreshControl()
            let action: UIAction = UIAction(handler: { handler in
                let sender = handler.sender as? UIRefreshControl
                withAnimation(.easeInOut(duration: 0.5)) {
                    uiScrollView.contentInset = UIEdgeInsets()
                }
                sender?.endRefreshing()
                Task {
                    await action()
                }
            })
            refreshControl.addAction(action, for: .valueChanged)
            uiScrollView.invalidateIntrinsicContentSize()
            uiScrollView.refreshControl = refreshControl
        })
    }
}
