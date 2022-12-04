//
//  LogoType.swift
//  Salmonia3+
//  
//  Created by devonly on 2022/11/27
//  Copyright © 2022 Magi Corporation. All rights reserved.
//

import Foundation
import SwiftUI

enum LogoType: String, CaseIterable {
    case Logo2
    case Logo3
    case Logo3_Pre
    case Switch
}

extension Image {
    init(logo bundle: LogoType) {
        self.init("Logo/\(bundle.rawValue)", bundle: .main)
    }
}
