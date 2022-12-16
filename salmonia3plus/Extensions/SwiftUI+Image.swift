//
//  SwiftUI+Image.swift
//  Salmonia3+
//  
//  Created by devonly on 2022/12/16
//  Copyright © 2022 Magi Corporation. All rights reserved.
//

import Foundation
import SwiftUI

extension Image {
    func scaledToFit(width: CGFloat) -> some View {
        self
            .resizable()
            .scaledToFit()
            .frame(width: width)
    }

    func scaledToFit(frame: CGSize, padding: CGFloat = .zero) -> some View {
        self
            .resizable()
            .scaledToFit()
            .padding(.all, padding)
            .frame(width: frame.width, height: frame.height)
    }
}
