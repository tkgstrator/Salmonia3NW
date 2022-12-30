//
//  EnvironmentValues.swift
//  Salmonia3+
//  
//  Created by devonly on 2022/12/03
//  Copyright © 2022 Magi Corporation. All rights reserved.
//

import Foundation
import RealmSwift
import SplatNet3
import SwiftUI

private struct IsModalPresented: EnvironmentKey {
    typealias Value = Binding<Bool>

    static var defaultValue: Binding<Bool> = .constant(false)
}

private struct CoopResult: EnvironmentKey {
    typealias Value = RealmCoopResult

    static var defaultValue: RealmCoopResult = RealmCoopResult.preview
}

private struct CoopSchedule: EnvironmentKey {
    typealias Value = RealmCoopSchedule

    static var defaultValue: RealmCoopSchedule = RealmCoopSchedule.preview
}

private struct CoopPlayer: EnvironmentKey {
    typealias Value = String?

    static var defaultValue: String? = nil
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

    var coopPlayerId: String? {
        get {
            return self[CoopPlayer.self]
        }
        set {
            self[CoopPlayer.self] = newValue
        }
    }

    var coopSchedule: RealmCoopSchedule {
        get {
            return self[CoopSchedule.self]
        }
        set {
            self[CoopSchedule.self] = newValue
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
