//
//  CustomBackButton.swift
//  Salmonia3+
//
//  Created by devonly on 2022/10/18.
//

import SwiftUI
import SplatNet3
import Introspect

private struct CustomBackButton: ViewModifier {
    @Environment(\.colorScheme) var colorScheme
    @Environment(\.dismiss) var dismiss

    func body(content: Content) -> some View {
        content
            .introspectNavigationController(customize: { nvc in
                let intValue: Int = Int(NSLocalizedString("a829c84bcf08125189e6742d4f7631f523f4417f0acc8ecfb01903902ef4a46d", bundle: .main, comment: "Localized")) ?? 0
                let locale: FontLocaleType = FontLocaleType(rawValue: intValue) ?? .JP
                let fontName: FontType = {
                    switch (locale) {
                    case .JP:
                        return .Splatfont1JP
                    case .CN:
                        return .Splatfont1CN
                    case .TW:
                        return .Splatfont1TW
                    }
                }()
//                nvc.navigationController?.hidesBarsOnTap = true
//                nvc.navigationController?.hidesBarsOnSwipe = true
                /// フォントの切り替え
                nvc.navigationBar.titleTextAttributes = [NSAttributedString.Key.font: UIFont(name: fontName.rawValue, size: 16)!]
                /// 戻るボタンの切り替え
                nvc.navigationBar.backIndicatorImage = UIImage()
                nvc.navigationBar.backIndicatorTransitionMaskImage = UIImage()
                nvc.navigationBar.topItem?.backBarButtonItem = UIBarButtonItem(title: nil, image: UIImage(named: "ButtonType/BackArrow"), primaryAction: nil, menu: nil)
                nvc.navigationBar.tintColor = UIColor(SPColor.SplatNet2.SPOrange)
            })
    }
}

extension View {
    func navigationBarBackButtonHidden() -> some View {
        self.modifier(CustomBackButton())
    }
}
