//
//  SwiftUI+Image.swift
//  Salmonia3+
//
//  Created by devonly on 2022/09/16.
//

import Foundation
import SwiftUI
import SplatNet3

enum IkuraType: Int, CaseIterable, Codable {
    case Power  = 0
    case Golden = 1
}

enum StatusType: Int, CaseIterable, Codable {
    case Rescue = 0
    case Death  = 1
}

extension Image {
    init(bundle: WeaponType) {
        let rawValue: Int = bundle.id ?? 0

        self.init("WeaponType/\(rawValue)", bundle: .main)
    }

    init(bundle: StageType) {
        let rawValue: Int = bundle.id ?? 0

        self.init("StageType/\(rawValue)", bundle: .main)
    }

    init(bundle: SpecialType) {
        let rawValue: Int = bundle.id ?? 0

        self.init("SpecialType/\(rawValue)", bundle: .main)
    }

    init(bundle: IkuraType) {
        self.init("IkuraType/\(bundle.rawValue)", bundle: .main)
    }

    init(bundle: StatusType) {
        self.init("StatusType/\(bundle.rawValue)", bundle: .main)
    }

    init(bundle: SakelienType) {
        let rawValue: Int = bundle.id ?? 0

        self.init("SakelienType/\(rawValue)", bundle: .main)
    }
}
