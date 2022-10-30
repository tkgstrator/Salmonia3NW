//
//  EnvironmentValues.swift
//  Salmonia3+
//
//  Created by devonly on 2022/09/22.
//

import Foundation
import SwiftUI

enum ResultStyle: CaseIterable {
    case SPLATNET2
    case SPLATNET3
}

struct ModalTransitionStyleKey: EnvironmentKey {
    typealias Value = UIModalTransitionStyle

    static var defaultValue: UIModalTransitionStyle = .coverVertical
}

struct StartTimeKey: EnvironmentKey {
    typealias Value = Date?

    static var defaultValue: Date? = nil
}

struct ResultFormatType: EnvironmentKey {
    typealias Value = ResultStyle

    static var defaultValue: ResultStyle = .SPLATNET3
}

struct IsNameVisible: EnvironmentKey {
    typealias Value = Bool

    static var defaultValue: Bool = true
}

struct IsModalPresented: EnvironmentKey {
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

    public var selection: ModeType

    public var rawValue: String {
        selection.mode
    }

    private func next() {
        self.selection.next()
    }

    public init(_ selection: ModeType) {
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

extension EnvironmentValues {
    var resultStyle: ResultStyle {
        get {
            return self[ResultFormatType.self]
        }

        set {
            self[ResultFormatType.self] = newValue
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

    var startTime: Date? {
        get { self[StartTimeKey.self] }
        set { self[StartTimeKey.self] = newValue }
    }

    var transitionStyle: UIModalTransitionStyle {
        get { self[ModalTransitionStyleKey.self] }
        set { self[ModalTransitionStyleKey.self] = newValue }
    }
}
