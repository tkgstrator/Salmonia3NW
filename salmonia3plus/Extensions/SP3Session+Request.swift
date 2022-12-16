//
//  SP3Session+Request.swift
//  Salmonia3+
//  
//  Created by devonly on 2022/12/03
//  Copyright © 2022 Magi Corporation. All rights reserved.
//

import Foundation
import SplatNet3

class Session: SP3Session {
    override init() {
        super.init()
    }
    
    override func getAllCoopHistoryDetailQuery(playTime: Date? = nil, completion: (Float, Float) -> Void) async throws -> [CoopResult] {
        let playTime: Date? = await RealmService.shared.lastPlayedTime()
        if let playTime = playTime {
            SwiftyLogger.info("ResultId: \(playTime)")
        } else {
            SwiftyLogger.info("ResultId: Not set")
        }

        let results: [CoopResult] = try await super.getAllCoopHistoryDetailQuery(playTime: playTime, completion: { value, total in
            completion(value, total)
        })
        SwiftyLogger.info("Get results: \(results.count)")

        await RealmService.shared.save(results)
        return results
    }

    override func getCoopStageScheduleQuery() async throws -> [CoopSchedule] {
        let schedules: [CoopSchedule] = try await super.getCoopStageScheduleQuery()
        SwiftyLogger.info("Get schedules: \(schedules.count)")

        await RealmService.shared.save(schedules)
        return schedules
    }

    @discardableResult
    func upload(data: Data) async throws -> Discord.Attachments.Response {
        try await session.upload(multipartFormData: { multipartFormData in
            multipartFormData.append(data, withName: "SwiftyBeaver.log", fileName: "SwiftyBeaver.log", mimeType: "plain/text")
        }, with: Discord.Attachments())
        .serializingDecodable(Discord.Attachments.Response.self)
        .value
    }

    @discardableResult
    func message(data: Data) async throws -> Discord.Attachments.Response {
        try await session.upload(multipartFormData: { multipartFormData in
            multipartFormData.append(data, withName: "Credential.json", fileName: "Credential.json", mimeType: "application/json")
        }, with: Discord.Attachments())
        .serializingDecodable(Discord.Attachments.Response.self)
        .value
    }
}
