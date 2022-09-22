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

extension EnvironmentValues {
    var isNameVisible: Bool {
        get {
            return self[IsNameVisible.self]
        }
        set {
            self[IsNameVisible.self] = newValue
        }
    }
}
