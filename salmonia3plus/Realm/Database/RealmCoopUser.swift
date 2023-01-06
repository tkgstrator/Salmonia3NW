//
//  RealmCoopUser.swift
//  SplatNetDemo
//
//  Created by devonly on 2022/11/27.
//

import Foundation
import RealmSwift
import SplatNet3

public final class RealmCoopUser: Object, Identifiable {
    @Persisted(primaryKey: true) public var id: String
    @Persisted var shiftsWorked: Int
    @Persisted var ikuraNum: Int
    @Persisted var goldenIkuraNum: Int
    @Persisted var helpCount: Int
    @Persisted var totalKumaPoint: Int
    @Persisted var defeatedBossCount: Int

    convenience init(uid: String, _ pointCard: CoopHistoryQuery.PointCard) {
        self.init()
        self.id = uid
        self.shiftsWorked = pointCard.playCount
        self.ikuraNum = pointCard.deliverCount
        self.goldenIkuraNum = pointCard.goldenDeliverCount
        self.helpCount = pointCard.rescueCount
        self.totalKumaPoint = pointCard.totalPoint
        self.defeatedBossCount = pointCard.defeatBossCount
    }
}
