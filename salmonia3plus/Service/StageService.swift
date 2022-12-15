//
//  StageService.swift
//  Salmonia3+
//  
//  Created by devonly on 2022/12/15
//  Copyright © 2022 Magi Corporation. All rights reserved.
//

import Foundation
import RealmSwift
import SplatNet3

class StageRecord: ObservableObject {
    @Published var stageId: CoopStageId = .Unknown
    @Published var counts: Int = 0
    @Published var maxGrade: GradeId? = nil
    @Published var maxGradePoint: Int? = nil
    @Published var hitting999Counts: Int? = nil
    @Published var maxGoldenIkuraNum: Int? = nil
    @Published var maxIkuraNum: Int? = nil

    init(stageId: CoopStageId, results: RealmSwift.Results<RealmCoopResult>) {
        self.stageId = stageId
        self.counts = results.count
        let maxGrade: GradeId? = results.max(ofProperty: "grade")
        self.maxGrade = maxGrade
        self.maxGradePoint = {
            guard let maxGrade = maxGrade else {
                return nil
            }
            return results.filter("grade=%@", maxGrade).max(ofProperty: "gradePoint")
        }()
        self.maxGoldenIkuraNum = results.max(ofProperty: "goldenIkuraNum")
        self.maxIkuraNum = results.max(ofProperty: "ikuraNum")
    }
}
