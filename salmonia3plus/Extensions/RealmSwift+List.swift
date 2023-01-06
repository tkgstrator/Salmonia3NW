//
//  RealmSwift+List.swift
//  Salmonia3+
//  
//  Created by devonly on 2023/01/07
//  Copyright © 2023 Magi Corporation. All rights reserved.
//

import Foundation
import RealmSwift

extension RealmSwift.List {
    convenience init<T: Sequence>(contentsOf objects: T) where T.Element == Element {
        self.init()
        self.append(objectsIn: objects)
    }
}

extension RealmSwift.List where Element == Int {
    func add(contentsOf content: RealmSwift.List<Int>?) {
        if let content = content {
            let results: [Int] = zip(self, content).map({ $0.0 + $0.1 })
            self.removeAll()
            self.append(objectsIn: results)
        }
    }
}
