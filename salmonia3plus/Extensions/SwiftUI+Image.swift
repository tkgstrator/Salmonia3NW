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

    func scaledToFit(frame: CGSize) -> some View {
        self
            .resizable()
            .scaledToFit()
            .frame(width: frame.width, height: frame.height)
    }
}
