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

struct IsModalPresented: EnvironmentKey {
    typealias Value = Binding<Bool>

    static var defaultValue: Binding<Bool> = .constant(false)
}

struct IsOAuthPresented: EnvironmentKey {
    typealias Value = Binding<Bool>

    static var defaultValue: Binding<Bool> = .constant(false)
}

struct TabSelectionKey: EnvironmentKey {
    typealias Value = Binding<Int>

    static var defaultValue: Binding<Int> = .constant(0)
}

extension EnvironmentValues {
    /// モーダルが表示されているかどうかを取得する環境変数
    var isModalPresented: Binding<Bool> {
        get {
            return self[IsModalPresented.self]
        }
        set {
            self[IsModalPresented.self] = newValue
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

    /// 初回起動かどうかを取得する環境変数
    var isFirstLaunch: Binding<Bool> {
        get {
            return self[IsFirstLaunch.self]
        }
        set {
            self[IsFirstLaunch.self] = newValue
        }
    }

    /// プレイヤー名が非表示になっているかどうかを取得する環境変数
    var isNameVisible: Bool {
        get {
            return self[IsNameVisible.self]
        }
        set {
            self[IsNameVisible.self] = newValue
        }
    }

    /// 現在表示されているタブを取得する環境変数
    var selection: Binding<Int> {
        get { self[TabSelectionKey.self] }
        set { self[TabSelectionKey.self] = newValue }
    }
}
