//
//  AnimatableModifier.swift
//  Salmonia3+
//
//  Created by devonly on 2022/10/14.
//

import Foundation
import SwiftUI

struct AnimatableNumberModifier: AnimatableModifier {
    var number: Double

    var animatableData: Double {
        get { number }
        set { number = newValue }
    }

    func body(content: Content) -> some View {
        content
            .overlay(Text(String(format: "%.1f", number)).font(.system(size: 16, design: .monospaced)), alignment: .trailing)
    }
}
