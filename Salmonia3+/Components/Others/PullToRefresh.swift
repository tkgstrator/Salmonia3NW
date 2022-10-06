//
//  PullToRefresh.swift
//  Salmonia3+
//
//  Created by devonly on 2022/10/06.
//

import Foundation
import Introspect
import SwiftUI

typealias OnRefresh = (_ done: @escaping () -> Void) -> Void

struct PullToRefresh: UIViewRepresentable {
    // この型はCase3と同様
    let onRefresh: OnRefresh

    class Coordinator {
        private let onRefresh: OnRefresh

        init(onRefresh: @escaping OnRefresh) {
            self.onRefresh = onRefresh
        }

        // UIControl.addTargetにてselectorを指定するためにCoordinatorというclassオブジェクトで制御する
        @objc func onValueChanged(sender: UIRefreshControl) {
            onRefresh(sender.endRefreshing)
        }
    }

    func makeCoordinator() -> Coordinator {
        Coordinator(onRefresh: onRefresh)
    }

    func makeUIView(context: UIViewRepresentableContext<PullToRefresh>) -> UIView {
        // ダミーのUIViewを作成
        let view = UIView(frame: .zero)
        view.isHidden = true
        view.isUserInteractionEnabled = false
        return view
    }

    func updateUIView(_ uiView: UIView, context: UIViewRepresentableContext<PullToRefresh>) {
        // Introspectでの検出が非同期実行でないと取れない
        DispatchQueue.main.async {
            if let scrollView = self.scrollView(entry: uiView),
               scrollView.refreshControl == nil {
                // 一度だけ呼ばれてセットされる
                let refreshControl = UIRefreshControl()
                refreshControl.addTarget(context.coordinator, action: #selector(Coordinator.onValueChanged), for: .valueChanged)
                scrollView.refreshControl = refreshControl
            }
        }
    }

    /// IntrospectでダミーのUIViewの先祖を再帰的に探査してUIScrollViewのインスタンスを検出する
    private func scrollView(entry: UIView) -> UIScrollView? {
        if let scrollView = Introspect.findAncestor(ofType: UIScrollView.self, from: entry) {
            return scrollView
        }

        guard let viewHost = Introspect.findViewHost(from: entry) else {
            return nil
        }

        return Introspect.previousSibling(containing: UIScrollView.self, from: viewHost)
    }
}

// ScrollViewではUIScrollViewを検出できず動作しないためListのextensionとしている
extension List {
    func refreshable(onRefresh: @escaping OnRefresh) -> some View {
        overlay(PullToRefresh(onRefresh: onRefresh).frame(width: 0, height: 0))
    }
}
