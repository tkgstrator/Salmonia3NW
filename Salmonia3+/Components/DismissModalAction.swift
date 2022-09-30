//
//  DismissModalAction.swift
//
//
//  Created by devonly on 2022/03/04.
//

import Foundation
import SwiftUI

@available(iOS 15.0, macOS 12.0, tvOS 15.0, watchOS 8.0, *)
public class DismissModalAction {
    private var isPresented: Binding<Bool>

    private func dismiss() {
        isPresented.wrappedValue.toggle()
//        UIApplication.shared.dismiss()
    }

    public func callAsFunction() { dismiss() }

    public init(_ isPresented: Binding<Bool>) {
        self.isPresented = isPresented
    }
}

@available(iOS 15.0, macOS 12.0, tvOS 15.0, watchOS 8.0, *)
struct DismissModalKey: EnvironmentKey {
    static var defaultValue: DismissModalAction = DismissModalAction(.constant(false))

    typealias Value = DismissModalAction
}

@available(iOS 15.0, macOS 12.0, tvOS 15.0, watchOS 8.0, *)
public extension EnvironmentValues {
    /// Dismisses the current presentation.
    var dismissModal: DismissModalAction {
        get { self[DismissModalKey.self] }
        set { self[DismissModalKey.self] = newValue }
    }
}
