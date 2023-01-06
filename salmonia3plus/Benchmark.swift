//
//  Benchmark.swift
//  Salmonia3+
//  
//  Created by devonly on 2023/01/06
//  Copyright © 2023 Magi Corporation. All rights reserved.
//

import Foundation
import os.signpost

@discardableResult
func benchmark<T>(_ name: String, function: () -> T) -> T{
    let log: OSLog = OSLog(subsystem: Bundle.main.bundleIdentifier!, category: name)
    os_signpost(.begin, log: log, name: "Benchmark")
    let startTime: Date = Date()
    let result: T = function()
    let timeInterval: TimeInterval = abs(Date().distance(to: startTime))
    print(String(format: "%.3fms", timeInterval * 1000))
    os_signpost(.end, log: log, name: "Benchmark")
    return result
}
