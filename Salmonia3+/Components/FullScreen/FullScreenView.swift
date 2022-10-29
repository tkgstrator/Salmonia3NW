//
//  ModalView.swift
//
//  SwiftyUI
//  Created by devonly on 2021/08/13.
//
//  Magi Corporation, All rights, reserved.

import SwiftUI

struct FullScreen<Content: View>: UIViewControllerRepresentable {
    let content: Content
    @Binding var isPresented: Bool
    let transitionStyle: UIModalTransitionStyle = .coverVertical
    let presentationStyle: UIModalPresentationStyle = .overFullScreen
    let isModalInPresentation: Bool = false

    init(isPresented: Binding<Bool>,
         content: Content
    ) {
        self.content = content
        self._isPresented = isPresented
    }

    func makeCoordinator() -> Coordinator {
        Coordinator(self)
    }

    func makeUIViewController(context: Context) -> ViewController<Content> {
        return ViewController(coordinator: context.coordinator, content: content)
    }

    func updateUIViewController(
        _ uiViewController: ViewController<Content>,
        context: Context
    ) {
        context.coordinator.parent = self
        uiViewController.parent?.presentationController?.delegate = context.coordinator

        switch isPresented {
        case true:
            uiViewController.present()
        case false:
            uiViewController.dismiss()
        }
    }

    class Coordinator: NSObject, UIAdaptivePresentationControllerDelegate {
        var parent: FullScreen

        init(_ parent: FullScreen) {
            self.parent = parent
        }

        // 画面外タップでViewをとじたときに呼ばれる
        func presentationControllerDidDismiss(_ presentationController: UIPresentationController) {
            if parent.isPresented {
                parent.isPresented = false
            }
        }
    }

    final class HostingController<Content: View>: UIHostingController<Content> {
        init(content: Content) {
            super.init(rootView: content)
        }

        required init?(coder: NSCoder) {
            fatalError("init(coder:) has not been implemented")
        }
    }

    // This custom view controller
    final class ViewController<Content: View>: UIViewController {
        let coordinator: FullScreen<Content>.Coordinator
        let hosting: UIHostingController<Content>

        init(coordinator: FullScreen<Content>.Coordinator,
             content: Content
        ) {
            self.coordinator = coordinator
            self.hosting = UIHostingController(rootView: content)
            super.init(nibName: nil, bundle: .main)
        }

        required init?(coder: NSCoder) {
            fatalError("init(coder:) has not been implemented")
        }

        override func dismiss(animated flag: Bool, completion: (() -> Void)? = nil) {
            if coordinator.parent.isPresented {
                coordinator.parent.isPresented.toggle()
            }
            super.dismiss(animated: flag, completion: completion)
        }

        // 表示
        func present() {
            // Hostingの設定
            hosting.modalTransitionStyle = .coverVertical
            hosting.modalPresentationStyle = .overFullScreen
            hosting.isModalInPresentation = true
            hosting.view.backgroundColor = UIColor(red: 0, green: 0, blue: 0, alpha: 0.3)
            hosting.presentationController?.delegate = coordinator as UIAdaptivePresentationControllerDelegate

            if let _ = presentedViewController?.isBeingPresented {} else {
                present(hosting, animated: true, completion: nil)
            }
        }

        // 表示されているViewがあるときだけとじる
        func dismiss() {
            dismiss(animated: true, completion: nil)
        }
    }
}
