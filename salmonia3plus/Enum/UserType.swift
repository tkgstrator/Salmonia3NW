//
//  UserType.swift
//  Salmonia3+
//  
//  Created by devonly on 2022/12/10
//  Copyright © 2022 Magi Corporation. All rights reserved.
//

import Foundation
import SwiftUI

enum UserType: String, CaseIterable, Identifiable {
    var id: String { rawValue }
    case Tkgling
    case Chiroru
    case Momizi
    case Oshake0809
    case RapieriHue
    case Tondemo71zasso

    var name: String {
        switch self {
        case .Tkgling:
            return "@tkgling"
        case .Chiroru:
            return "@ChiroruSPLT"
        case .Momizi:
            return "@momizi"
        case .Oshake0809:
            return "@oshake0809"
        case .RapieriHue:
            return "@rapieriHue"
        case .Tondemo71zasso:
            return "@tondemo71_zasso"
        }
    }

    var role: RoleType {
        switch self {
        case .Tkgling:
            return .Developer
        case .Chiroru, .Momizi, .Oshake0809, .RapieriHue, .Tondemo71zasso:
            return .Tester
        }
    }
}

extension Image {
    init(user: UserType) {
        self.init("Developer/\(user.rawValue.lowercased())", bundle: .main)
    }
}
