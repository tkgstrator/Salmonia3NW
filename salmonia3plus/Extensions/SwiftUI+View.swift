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
    func font(systemName: FontType, size: CGFloat) -> some View {
        return self.font(.custom(systemName.rawValue, size: size))
    }

    func showsScrollIndicators(_ value: Bool = false) -> some View {
        if #available(iOS 16.0, *) {
            return self.scrollIndicators(.hidden)
        } else {
            return self
        }
    }
}

struct GoldenIkura: View {
    let frame: CGSize

    var body: some View {
        Image(icon: .GoldenIkura)
            .resizable()
            .scaledToFit()
            .frame(width: frame.width, height: frame.height, alignment: .center)
    }
}

struct Ikura: View {
    let frame: CGSize

    var body: some View {
        Image(icon: .Ikura)
            .resizable()
            .scaledToFit()
            .frame(width: frame.width, height: frame.height, alignment: .center)
    }
}
