//
//  SwiftUI+View.swift
//  Salmonia3+
//
//  Created by tkgstrator on 2022/09/16.
//

import Foundation
import SwiftUI

enum FontLocaleType: Int, CaseIterable {
    case JP = 0
    case CN = 1
    case TW = 2
}

enum FontStyle: CaseIterable {
    case Splatfont
    case Splatfont2
}

enum FontType: String, CaseIterable {
    case Splatfont1JP = "splatoon1jpja"
    case Splatfont1CN = "splatoon1chzh"
    case Splatfont1TW = "splatoon1twzh"
    case Splatfont2JP = "splatoon2jpja"
    case Splatfont2CN = "splatoon2chzh"
    case Splatfont2TW = "splatoon2twzh"
}

extension View {
    func frame(maxWidth: CGFloat, height: CGFloat, alignment: Alignment) -> some View{
        self.frame(maxWidth: maxWidth, alignment: alignment).frame(height: height)
    }
    
    func font(systemName: FontStyle, size: CGFloat) -> some View {
        let intValue: Int = Int(NSLocalizedString("a829c84bcf08125189e6742d4f7631f523f4417f0acc8ecfb01903902ef4a46d", bundle: .main, comment: "Localized")) ?? 0
        let locale: FontLocaleType = FontLocaleType(rawValue: intValue) ?? .JP

        let fontName: FontType = {
            switch (locale, systemName) {
            case (.JP, .Splatfont):
                return .Splatfont1JP
            case (.JP, .Splatfont2):
                return .Splatfont2JP
            case (.CN, .Splatfont):
                return .Splatfont1CN
            case (.CN, .Splatfont2):
                return .Splatfont2CN
            case (.TW, .Splatfont):
                return .Splatfont1TW
            case (.TW, .Splatfont2):
                return .Splatfont2TW
            }
        }()

        return self.font(.custom(fontName.rawValue, size: size))
    }
}
