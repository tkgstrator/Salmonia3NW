//
//  Session.swift
//  Salmonia3+
//  
//  Created by devonly on 2022/11/27
//  Copyright © 2022 Magi Corporation. All rights reserved.
//

import Foundation
import SplatNet3

public class Session: SPSession {
//    override public func getAllCoopHistoryDetailQuery() async throws -> [CoopResult] {
//        let results: [CoopResult] = try await super.getAllCoopHistoryDetailQuery()
//        await RealmService.shared.save(results)
//        return results
//}
    override init() {
        super.init()
    }
}
