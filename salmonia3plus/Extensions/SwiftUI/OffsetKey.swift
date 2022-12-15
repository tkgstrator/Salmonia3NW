//
//  OffsetKey.swift
//  Salmonia3+
//  
//  Created by devonly on 2022/12/16
//  Copyright © 2022 Magi Corporation. All rights reserved.
//

import Foundation
import SwiftUI

struct OffsetKey: PreferenceKey {
    static var defaultValue: CGFloat = 0

    static func reduce(value: inout CGFloat, nextValue: () -> CGFloat) {
        value = nextValue()
    }
}
