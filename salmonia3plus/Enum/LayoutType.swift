//
//  LayoutType.swift
//  Salmonia3+
//  
//  Created by devonly on 2022/12/15
//  Copyright © 2022 Magi Corporation. All rights reserved.
//

import Foundation
import SwiftUI

enum LayoutType: String, CaseIterable {
    case GftCoopResult_00
    case GftCoopResult_01
    case GftCoopResult_02
    case GftCoopResult_03
    case GftCoopResult_04
    case GftCoopResult_05
    case GftCoopResult_06
    case GftCoopResult_07
    case GftCoopResult_08
    case GftCoopResult_09
    case GftCoopResult_10
    case GftCoopResult_11
    case GftCoopResult_12
    case GftCoopResult_13
    case GftCoopResult_14
    case GftCoopResult_15
    case GftCoopResult_16
    case GftCoopResult_17
    case GftCoopResult_18
    case GftCoopResult_19
    case GftCoopResult_20
    case InkBtn_4
    case InkBtn_5
    case InkBtn_6
    case InkBtn_11
    case InkBtn_12
    case InkBtn_13
    case InkBtn_14
    case InkBtn_15
    case InkBtn_16
    case WinTalkPattern_02
    case Frame_00
}

extension Image {
    init(layout: LayoutType) {
        self.init("Layout/\(layout.rawValue)", bundle: .main)
    }
}
