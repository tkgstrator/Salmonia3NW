//
//  SwiftUI+View.swift
//  Salmonia3+
//  
//  Created by devonly on 2022/11/27
//  Copyright © 2022 Magi Corporation. All rights reserved.
//

import Foundation
import SwiftUI

extension View {
    /// フォントを変更する
    func font(systemName: FontType, size: CGFloat) -> some View {
        return self.font(.custom(systemName.rawValue, size: size))
    }

    /// スクロールビューのIndicatorを非表示にする
    func showsScrollIndicators(_ value: Bool = false) -> some View {
        if #available(iOS 16.0, *) {
            return self.scrollIndicators(.hidden)
        } else {
            return self
        }
    }
}
