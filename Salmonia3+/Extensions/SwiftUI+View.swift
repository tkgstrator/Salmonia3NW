//
//  SwiftUI+View.swift
//  Salmonia3+
//
//  Created by devonly on 2022/09/16.
//

import Foundation
import SwiftUI

enum FontStyle: String, CaseIterable {
    case Splatfont = "Splatfont"
    case Splatfont2 = "Splatfont2"
}

extension View {
    func font(systemName: FontStyle, size: CGFloat) -> some View {
        self.font(.custom(systemName.rawValue, size: size))
    }
}
