//
//  SwiftUI+GeometryReader.swift
//  Salmonia3+
//
//  Created by devonly on 2022/09/17.
//

import Foundation
import SwiftUI

extension GeometryProxy {
    var width: CGFloat {
        frame(in: .local).width
    }

    var height: CGFloat {
        frame(in: .local).height
    }

    var center: CGPoint {
        CGPoint(x: frame(in: .local).midX, y: frame(in: .local).midY)
    }
}
