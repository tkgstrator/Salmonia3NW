//
//  EnvironmentValues.swift
//  Salmonia3+
//  
//  Created by devonly on 2022/12/03
//  Copyright © 2022 Magi Corporation. All rights reserved.
//

import Foundation
import SwiftUI

private struct IsModalPresented: EnvironmentKey {
    typealias Value = Binding<Bool>

    static var defaultValue: Binding<Bool> = .constant(false)
}

private struct CoopResult: EnvironmentKey {
    typealias Value = RealmCoopResult

    static var defaultValue: RealmCoopResult = RealmCoopResult.preview
}

private struct RootPresentationModeKey: EnvironmentKey {
    static let defaultValue: Binding<RootPresentationMode> = .constant(RootPresentationMode())
}

typealias RootPresentationMode = Bool

extension RootPresentationMode {
    public mutating func dismiss() {
        self.toggle()
    }
}

extension EnvironmentValues {
    var rootPresentationMode: Binding<RootPresentationMode> {
        get {
            self[RootPresentationModeKey.self]
        }
        set {
            self[RootPresentationModeKey.self] = newValue
        }
    }

    var coopResult: RealmCoopResult {
        get {
            return self[CoopResult.self]
        }
        set {
            self[CoopResult.self] = newValue
        }
    }

    var isModalPresented: Binding<Bool> {
        get {
            return self[IsModalPresented.self]
        }
        set {
            self[IsModalPresented.self] = newValue
        }
    }

    var isPreview: Bool {
        #if DEBUG
        return ProcessInfo.processInfo.environment["XCODE_RUNNING_FOR_PREVIEWS"] == "1"
        #else
        return false
        #endif
    }
}
