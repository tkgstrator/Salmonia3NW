//
//  SP3Session+Request.swift
//  Salmonia3+
//  
//  Created by devonly on 2022/12/03
//  Copyright © 2022 Magi Corporation. All rights reserved.
//

import Foundation
import SplatNet3
import SwiftUI

class Session: SP3Session {
    @AppStorage(SceneKey.isResultUploadable.rawValue) var isResultUploadable: Bool = false

    override init() {
        super.init()
    }

    override func getCoopHistoryQuery() async throws -> CoopHistoryQuery.CoopResult {
        let response: CoopHistoryQuery.CoopResult = try await super.getCoopHistoryQuery()
        if let id: String = account?.id {
            RealmService.shared.save(uid: id, response.pointCard)
        }
        return response
    }

    override func getAllCoopHistoryDetailQuery(playTime: Date? = nil, upload: Bool = false, completion: (Float, Float) -> Void) async throws -> [CoopResult] {
        let playTime: Date? = RealmService.shared.lastPlayedTime()
        if let playTime = playTime {
            SwiftyLogger.info("ResultId: \(playTime)")
        } else {
            SwiftyLogger.info("ResultId: Not set")
        }

        let results: [CoopResult] = try await super.getAllCoopHistoryDetailQuery(playTime: playTime, upload: isResultUploadable, completion: { value, total in
            completion(value, total)
        })
        SwiftyLogger.info("Get results: \(results.count)")

        RealmService.shared.save(results)
        return results
    }

    override func getCoopStageScheduleQuery() async throws -> [CoopSchedule] {
        let schedules: [CoopSchedule] = try await super.getCoopStageScheduleQuery()
        SwiftyLogger.info("Get schedules: \(schedules.count)")

        RealmService.shared.save(schedules)
        return schedules
    }

    override func uploadAllCoopResultDetailQuery(results: [CoopResult] = [], completion: (Float, Float) -> Void) async throws -> [CoopStatsResultsQuery.Response] {
        let results: [CoopStatsResultsQuery.Response] = try await super.uploadAllCoopResultDetailQuery(results: results, completion: completion)
        try RealmService.shared.updateSalmonId(results: results)
        return results
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
