//
//  Decimal128.swift
//  Salmonia3+
//  
//  Created by devonly on 2022/12/10
//  Copyright © 2022 Magi Corporation. All rights reserved.
//

import Foundation
import RealmSwift

extension Decimal128 {
    var intValue: Int {
        Int(truncating: NSDecimalNumber(decimal: self.decimalValue))
    }

    var dobleValue: Double {
        Double(truncating: NSDecimalNumber(decimal: self.decimalValue))
    }
}
