//
//  StageStats.swift
//  Salmonia3+
//  
//  Created by devonly on 2022/12/15
//  Copyright © 2022 Magi Corporation. All rights reserved.
//

import Foundation
import RealmSwift
import SplatNet3

class StageStats: ObservableObject {
    @Published var stageId: CoopStageId = .Unknown
    @Published var counts: Int = 0
    @Published var maxGrade: GradeId? = nil
    @Published var maxGradePoint: Int? = nil
    @Published var hitting999Counts: Int? = nil
    @Published var maxGoldenIkuraNum: Int? = nil
    @Published var maxIkuraNum: Int? = nil

    init() {}

    func calc(stageId: CoopStageId, results: RealmSwift.Results<RealmCoopResult>) {
        let results: RealmSwift.Results<RealmCoopResult> = results.filter("ANY link.stageId = %@", stageId)
        self.stageId = stageId
        self.counts = results.count
        let maxGrade: GradeId? = results.max(ofProperty: "gradeId")
        self.maxGrade = maxGrade
        self.maxGradePoint = {
            guard let maxGrade = maxGrade else {
                return nil
            }
            return results.filter("gradeId=%@", maxGrade).max(ofProperty: "gradePoint")
        }()
        self.maxGoldenIkuraNum = results.max(ofProperty: "goldenIkuraNum")
        self.maxIkuraNum = results.max(ofProperty: "ikuraNum")
    }
}
