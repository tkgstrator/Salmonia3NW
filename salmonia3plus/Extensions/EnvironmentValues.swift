//
//  EnvironmentValues.swift
//  Salmonia3+
//  
//  Created by devonly on 2022/12/03
//  Copyright © 2022 Magi Corporation. All rights reserved.
//

import Foundation
import SwiftUI

struct IsModalPresented: EnvironmentKey {
    typealias Value = Binding<Bool>

    static var defaultValue: Binding<Bool> = .constant(false)
}

extension EnvironmentValues {
    var isModalPresented: Binding<Bool> {
        get {
            return self[IsModalPresented.self]
        }
        set {
            self[IsModalPresented.self] = newValue
        }
    }
}
