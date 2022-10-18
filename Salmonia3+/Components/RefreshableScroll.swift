//
//  RefreshableScroll.swift
//  Salmonia3+
//
//  Created by devonly on 2022/10/18.
//

import SwiftUI
import Introspect

extension ScrollView {
    /// Marks ScrollView as refreshable.
    func refreshable(action: @escaping () async -> Void) -> some View {
        self
            .introspectScrollView(customize: { uiScrollView in
                let refreshControl: UIRefreshControl = UIRefreshControl()
                let action: UIAction = UIAction(handler: { handler in
                    let sender = handler.sender as? UIRefreshControl
                    sender?.endRefreshing()
                    Task {
                        await action()
                    }
                })
                refreshControl.addAction(action, for: .valueChanged)
                uiScrollView.refreshControl = refreshControl
            })
    }
}
