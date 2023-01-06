//
//  Date.swift
//  Salmonia3+
//  
//  Created by devonly on 2023/01/07
//  Copyright © 2023 Magi Corporation. All rights reserved.
//

import Foundation

extension Date {
    init(iso8601: String) {
        let formatter: ISO8601DateFormatter = ISO8601DateFormatter()
        self.init(timeIntervalSince1970: formatter.date(from: iso8601)?.timeIntervalSince1970 ?? 0)
    }
}
