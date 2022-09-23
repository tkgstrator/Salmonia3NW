//
//  EnvironmentValues.swift
//  Salmonia3+
//
//  Created by devonly on 2022/09/22.
//

import Foundation
import SwiftUI

struct IsNameVisible: EnvironmentKey {
    typealias Value = Bool

    static var defaultValue: Bool = true
}

struct IsFirstLaunch: EnvironmentKey {
    typealias Value = Binding<Bool>

    static var defaultValue: Binding<Bool> = .constant(true)
}

public struct PresentationStyle {
    public var isPresented: Binding<Bool>

    public mutating func dismiss() {
        guard let window = UIApplication.shared.connectedScenes
                .filter({ $0.activationState == .foregroundActive })
                .compactMap({ $0 as? UIWindowScene })
                .first?.windows
                .filter({ $0.isKeyWindow })
                .first else { return }
        guard let nvc = window.rootViewController?.children.first as? UINavigationController else { return }
        nvc.dismiss(animated: true, completion: nil)
        isPresented.wrappedValue = false
    }

    public mutating func toggle() {
        isPresented.wrappedValue.toggle()
    }

    public init(_ isPresented: Binding<Bool>) {
        self.isPresented = isPresented
    }
}

struct IsModalPopuped: EnvironmentKey {
    typealias Value = Binding<Bool>

    static var defaultValue: Binding<Bool> = .constant(false)
}

extension EnvironmentValues {
    var isModalPopuped: Binding<Bool> {
        get {
            return self[IsModalPopuped.self]
        }
        set {
            self[IsModalPopuped.self] = newValue
        }
    }

    var isFirstLaunch: Binding<Bool> {
        get {
            return self[IsFirstLaunch.self]
        }
        set {
            self[IsFirstLaunch.self] = newValue
        }
    }

    var isNameVisible: Bool {
        get {
            return self[IsNameVisible.self]
        }
        set {
            self[IsNameVisible.self] = newValue
        }
    }
}
