//
//  IconType.swift
//  Salmonia3+
//  
//  Created by devonly on 2022/11/27
//  Copyright © 2022 Magi Corporation. All rights reserved.
//

import Foundation
import SwiftUI

enum IconType: String, CaseIterable {
    case Chart
    case Circle
    case Close
    case Defeated
    case Eye
    case EyeSlash
    case Flag
    case GoldenIkura
    case Ikura
    case Home
    case Me
    case Menu
    case Refresh
    case Squid
    case Swap
    case Switch
    case Update
}

extension Image {
    init(icon: IconType) {
        self.init("Icon/\(icon.rawValue)", bundle: .main)
    }
}
