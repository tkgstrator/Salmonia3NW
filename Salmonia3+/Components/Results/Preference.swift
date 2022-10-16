//
//  Preference.swift
//  Salmonia3+
//
//  Created by devonly on 2022/10/16.
//

import Foundation
import SwiftUI

struct ViewPreferenceKey: PreferenceKey {
    typealias Value = CGSize
    static var defaultValue: CGSize = .zero
    static func reduce(value: inout CGSize, nextValue: () -> CGSize) {
        value = nextValue()
    }
}

struct ViewAnchorKey: PreferenceKey {
    static let defaultValue = ViewAnchorData()
    static func reduce(value: inout ViewAnchorData, nextValue: () -> ViewAnchorData) {
        value.anchor = nextValue().anchor ?? value.anchor
    }
}

struct ViewAnchorData: Equatable {
    var anchor: Anchor<CGRect>? = nil
    static func == (lhs: ViewAnchorData, rhs: ViewAnchorData) -> Bool {
        return false
    }
}

struct ViewGeometry: View {
    var body: some View {
        GeometryReader(content: { geometry in
            Color
                .clear
                .preference(key: ViewPreferenceKey.self, value: geometry.size)
                .anchorPreference(key: ViewAnchorKey.self, value: .bounds, transform: { value in
                    ViewAnchorData(anchor: value)
                })
        })
    }
}

struct ScaleModifier: ViewModifier {
    let size: CGSize

    @State var horizontalScale: CGFloat = 1.0
    @State var verticallScale: CGFloat = 1.0

    public init(_ width: CGFloat = -1, _ height: CGFloat = -1) {
        self.size = CGSize(width: width, height: height)
    }

    func body(content: Content) -> some View {
        content
            .background(ViewGeometry())
            .scaleEffect(CGSize(width: min(1.0, horizontalScale), height: min(1.0, verticallScale)))
            .onPreferenceChange(ViewPreferenceKey.self, perform: { newSize in
                print(newSize)
            })
    }
}

extension View  {
    func scaledToContent() -> some View {
        self.modifier(ScaleModifier())
    }
}

struct Previews_Preference_Previews: PreviewProvider {
    static var previews: some View {
        /*@START_MENU_TOKEN@*/Text("Hello, World!")/*@END_MENU_TOKEN@*/
    }
}
