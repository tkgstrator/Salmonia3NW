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

struct IsModalPopuped: EnvironmentKey {
    typealias Value = Binding<Bool>

    static var defaultValue: Binding<Bool> = .constant(false)
}

struct IsOAuthPresented: EnvironmentKey {
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

    var isOAuthPresented: Binding<Bool> {
        get {
            return self[IsOAuthPresented.self]
        }
        set {
            self[IsOAuthPresented.self] = newValue
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
