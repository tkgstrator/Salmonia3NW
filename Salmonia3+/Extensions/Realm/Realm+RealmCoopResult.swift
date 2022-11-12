//
//  Realm+RealmCoopResult.swift
//  Salmonia3+
//
//  Created by devonly on 2022/11/12.
//

import Foundation
import SplatNet3
import RealmSwift

extension RealmCoopResult {
    /// 推定キケン度
    var estimatedDangerRate: Double? {
        guard let gradePoint = self.gradePoint, let grade = self.grade else {
            return nil
        }
        return min(333, Double(grade.rawValue * 100 + gradePoint) / Double(5))
    }

    /// 仲間の平均レート
    var gradePointCrew: Double? {
        guard let grade = self.grade,
              let gradePoint = self.gradePoint else {
            return nil
        }
        if self.dangerRate == .zero {
            return nil
        }
        return (self.dangerRate * 100 * 5 * 4 - Double(grade.rawValue * 100 + gradePoint)) / 3 - Double(grade.rawValue * 100)
    }
}
