//
//  FontType.swift
//  Salmonia3+
//  
//  Created by devonly on 2022/11/27
//  Copyright © 2022 Magi Corporation. All rights reserved.
//

import Foundation

enum FontType: RawRepresentable, CaseIterable {
    typealias RawValue = String

    var rawValue: String {
        switch self {
        case .Splatfont:
            return _FontType.Splatfont1JP.rawValue
        case .Splatfont2:
            return _FontType.Splatfont2JP.rawValue
        }
    }

    init?(rawValue: String) {
        fatalError()
    }

    case Splatfont
    case Splatfont2
}

private enum _FontType: String, CaseIterable {
    case Splatfont1JP = "splatoon1jpja"
    case Splatfont1CN = "splatoon1chzh"
    case Splatfont1TW = "splatoon1twzh"
    case Splatfont2JP = "splatoon2jpja"
    case Splatfont2CN = "splatoon2chzh"
    case Splatfont2TW = "splatoon2twzh"
}
