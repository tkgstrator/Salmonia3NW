//
//  PullToRefresh.swift
//  Salmonia3+
//
//  Created by tkgstrator on 2022/10/30.
//

import SwiftUI

/// リザルトがなにもないときに下スワイプで取得できることを表示する
private struct PullToRefreshView: View {
    var body: some View {
        VStack(alignment: .center, content: {
            Text(bundle: .Common_PullToRefresh)
                .font(systemName: .Splatfont, size: 24)
                .multilineTextAlignment(.center)
            Text("↓")
                .font(systemName: .Splatfont, size: 34)
        })
    }
}

extension View {
    /// 下に引っ張って更新を表示する
    func pullToRefresh(enabled: Bool) -> some View {
        self.overlay(enabled ? AnyView(PullToRefreshView()) : AnyView(EmptyView()))
    }
}

