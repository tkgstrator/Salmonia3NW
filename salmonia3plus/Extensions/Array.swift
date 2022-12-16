//
//  Array.swift
//  Salmonia3+
//  
//  Created by devonly on 2022/12/16
//  Copyright © 2022 Magi Corporation. All rights reserved.
//

import Foundation

extension Array {
    func chunked(by chunkSize: Int) -> [[Element]] {
        return stride(from: 0, to: self.count, by: chunkSize).map {
            Array(self[$0..<Swift.min($0 + chunkSize, self.count)])
        }
    }
}
