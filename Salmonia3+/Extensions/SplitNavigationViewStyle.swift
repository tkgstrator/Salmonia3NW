//
//  SplitNavigationViewStyle.swift
//
//  SwiftyUI
//  Created by devonly on 2021/08/27.
//
//  Magi Corporation, All rights, reserved.

import Foundation
import SwiftUI

public struct SplitNavigationViewStyle: NavigationViewStyle {
    @available(iOS 15, *)
    public func _columnBasedBody(configuration: _NavigationViewStyleConfiguration) -> EmptyView {
        EmptyView()
    }

    struct ControllerModifier: ViewModifier {
        struct ControllerView: UIViewControllerRepresentable {
            class ViewController: UIViewController {

                override func viewWillAppear(_ animated: Bool) {
                    super.viewWillAppear(animated)
                    guard let svc = self.parent?.children.first as? UISplitViewController else { return }
                    svc.preferredDisplayMode = .oneBesideSecondary
                    svc.preferredSplitBehavior = .tile
                    svc.presentsWithGesture = true
                }
            }

            func makeUIViewController(context: Self.Context) -> UIViewController {
                return ViewController()
            }

            func updateUIViewController(_ uiViewController: UIViewController, context: Self.Context) {
            }
        }

        func body(content: Content) -> some View {
            content
                .overlay(ControllerView().frame(width: 0, height: 0))
        }
    }

    public func _body(configuration: _NavigationViewStyleConfiguration) -> some View {
        NavigationView(content: {
            configuration.content
        })
        .modifier(ControllerModifier())
    }

    public init() {}
}

@available(iOS 13.0, tvOS 13.0, watchOS 7.0, *)
@available(macOS, unavailable)
extension NavigationViewStyle where Self == SplitNavigationViewStyle {

    /// A navigation view style split by master view and detail view.
    public static var split: SplitNavigationViewStyle { SplitNavigationViewStyle() }
}
