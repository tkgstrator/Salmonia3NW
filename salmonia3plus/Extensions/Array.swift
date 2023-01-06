//
//  Array.swift
//  Salmonia3+
//  
//  Created by devonly on 2022/12/16
//  Copyright © 2022 Magi Corporation. All rights reserved.
//

import Foundation
import RealmSwift

extension Collection where Element == List<Int> {
    func sum() -> Element {
        if let first = self.first {
            let sum: List<Int> = Element(contentsOf: Array(repeating: 0, count: first.count))
            self.forEach({ element in
                sum.add(contentsOf: element)
            })
            return sum
        }
        return List<Int>()
    }
}
