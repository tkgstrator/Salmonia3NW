//
//  SwiftUI+Color.swift
//  Salmonia3+
//
//  Created by devonly on 2022/09/17.
//

import Foundation
import SwiftUI

extension UIColor {
    convenience init(hex: String, alpha: CGFloat = 1.0) {
        let v = Int("000000" + hex, radix: 16) ?? 0
        let r = CGFloat(v / Int(powf(256, 2)) % 256) / 255
        let g = CGFloat(v / Int(powf(256, 1)) % 256) / 255
        let b = CGFloat(v / Int(powf(256, 0)) % 256) / 255
        self.init(red: r, green: g, blue: b, alpha: min(max(alpha, 0), 1))
    }
}

extension Color {
    public init(hex: String, alpha: CGFloat = 1.0) {
        self.init(UIColor(hex: hex, alpha: alpha))
    }

    static let themeColor: Color = Color("SPThemeColor", bundle: .main)
}
