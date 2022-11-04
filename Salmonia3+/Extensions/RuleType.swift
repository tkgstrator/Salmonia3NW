//
//  ModeType.swift
//  Salmonia3+
//
//  Created by tkgstrator on 2022/10/04.
//

import Foundation
import SwiftUI
import SplatNet3

public enum ModeType: String, CaseIterable {
    /// いつものバイト
    case CoopHistory_Regular    = "b17ef6b50176fc4b8cb03fd628fa2f60800890f7d1bf7ba2dafa1b3f874ce60b"
    /// プライベートバイト
    case CoopHistory_Private    = "bbf41509ad5857831616665e2937e91faacbac046a0a138e8faaed36525a62a5"

    var mode: String {
        switch self {
        case .CoopHistory_Regular:
            return Common.Mode.REGULAR.rawValue
        case .CoopHistory_Private:
            return Common.Mode.PRIVATE_CUSTOM.rawValue
        }
    }

    mutating func next() {
        if let firstIndex: Int = Self.allCases.firstIndex(of: self) {
           let nextIndex: Int = (firstIndex + 1) % Self.allCases.count
            self = Self.allCases[nextIndex]
        }
    }
}

extension Text {
    init(mode: ModeType) {
        switch mode {
        case .CoopHistory_Regular:
            self.init(bundle: .CoopHistory_Regular)
        case .CoopHistory_Private:
            self.init(bundle: .CoopHistory_Private)
        }
    }
}
