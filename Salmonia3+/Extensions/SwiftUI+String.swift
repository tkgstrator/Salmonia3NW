//
//  SwiftUI+String.swift
//  Salmonia3+
//
//  Created by tkgstrator on 2022/10/19.
//

import Foundation
import SwiftUI

extension String {
    init(format: String, _ value: Double?) {
        if let value = value {
            self.init(format: format, value)
        } else {
            self.init("-")
        }
    }

    init(format: String, _ value: Int?) {
        if let value = value {
            self.init(format: format, value)
        } else {
            self.init("-")
        }
    }
}
