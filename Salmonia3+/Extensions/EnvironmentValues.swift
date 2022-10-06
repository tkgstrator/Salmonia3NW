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
    typealias Value = Binding<String>

    static var defaultValue: Binding<String> = .constant("")
}

public class ResultRuleAction: Equatable {
    public static func == (lhs: ResultRuleAction, rhs: ResultRuleAction) -> Bool {
        lhs.rawValue == rhs.rawValue
    }

    public var selection: RuleType

    public var rawValue: String {
        selection.rule
    }

    private func next() {
        self.selection.next()
    }

    public init(_ selection: RuleType) {
        self.selection = selection
    }

    public func callAsFunction() {
        next()
    }
}

struct ResultRule: EnvironmentKey {
    typealias Value = ResultRuleAction

    static var defaultValue: ResultRuleAction = ResultRuleAction(.CoopHistory_Regular)

}

struct ScaleForView: EnvironmentKey {
    typealias Value = CGFloat

    static var defaultValue: CGFloat = 1.0
}

extension EnvironmentValues {
    /// モーダルが表示されているかどうかを取得する環境変数
    var resultRule: ResultRuleAction {
        get {
            return self[ResultRule.self]
        }
        set {
            self[ResultRule.self] = newValue
        }
    }

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
    var selection: Binding<String> {
        get { self[TabSelectionKey.self] }
        set { self[TabSelectionKey.self] = newValue }
    }

    var scale: CGFloat {
        get {
            return self[ScaleForView.self]
        }
        set {
            self[ScaleForView.self] = newValue
        }
    }
}
