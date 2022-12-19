//
//  ChartEntry.swift
//  Salmonia3+
//  
//  Created by devonly on 2022/12/16
//  Copyright © 2022 Magi Corporation. All rights reserved.
//

import Foundation

struct Entry<T: RawRepresentable, S: BinaryFloatingPoint>: Identifiable {
    let id: UUID = UUID()
    let key: T
    let x: S
    let y: S

    init(key: T, x: S, y: S) {
        self.key = key
        self.x = x
        self.y = y
    }
}
