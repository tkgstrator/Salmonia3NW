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

extension EnvironmentValues {
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
