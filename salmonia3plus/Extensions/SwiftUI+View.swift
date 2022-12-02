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
}
