//
//  ModalViewModifier.swift
//
//  SwiftyUI
//  Created by devonly on 2021/08/13.
//
//  Magi Corporation, All rights, reserved.

import SwiftUI

public extension View {
    /// モーダルをUIKit風に表示する
    func fullScreen<Content: View>(
        isPresented: Binding<Bool>,
        content: @escaping () -> Content
    ) -> some View {
        self.overlay(
            FullScreen(
                isPresented: isPresented,
                content: content())
            .frame(width: 0, height: 0)
        )
    }
}
