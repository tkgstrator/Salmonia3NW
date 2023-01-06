//
//  GeometryProxy.swift
//  Salmonia3+
//  
//  Created by devonly on 2023/01/07
//  Copyright © 2023 Magi Corporation. All rights reserved.
//

import Foundation
import SwiftUI

extension GeometryProxy {
    var center: CGPoint {
        CGPoint(x: self.frame(in: .local).midX, y: self.frame(in: .local).midY)
    }
}
