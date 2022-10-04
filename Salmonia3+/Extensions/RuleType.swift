//
//  RuleType.swift
//  Salmonia3+
//
//  Created by devonly on 2022/10/04.
//

import Foundation
import SwiftUI

enum RuleType: String, CaseIterable {
    /// いつものバイト
    case CoopHistory_Regular    = "b17ef6b50176fc4b8cb03fd628fa2f60800890f7d1bf7ba2dafa1b3f874ce60b"
    /// プライベートバイト
    case CoopHistory_Private    = "bbf41509ad5857831616665e2937e91faacbac046a0a138e8faaed36525a62a5"
}

extension Text {
    init(rule: RuleType) {
        switch rule {
        case .CoopHistory_Regular:
            self.init(bundle: .CoopHistory_Regular)
        case .CoopHistory_Private:
            self.init(bundle: .CoopHistory_Private)
        }
    }
}
