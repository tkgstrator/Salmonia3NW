//
//  ResultHeader.swift
//  Salmonia3+
//
//  Created by devonly on 2022/09/16.
//

import SwiftUI
import RealmSwift
import SplatNet3

struct ResultHeader: View {
    let schedule: RealmCoopSchedule

    var body: some View {
        GeometryReader(content: { geometry in
            let scale: CGFloat = geometry.height / 75
            ZStack(content: {
                Image(bundle: schedule.stageId)
                    .resizable()
                LazyVGrid(columns: Array(repeating: .init(.flexible(maximum: min(60, 36 * scale)), spacing: 0), count: schedule.weaponList.count),
                          alignment: .center,
                          content: {
                    ForEach(schedule.weaponList.indices, id: \.self) { index in
                        let weaponType: WeaponType = schedule.weaponList[index]
                        Image(bundle: weaponType)
                            .resizable()
                            .scaledToFit()
                    }
                })
                .frame(width: geometry.width * 0.45)
                .background(RoundedRectangle(cornerRadius: 40 * scale).fill(Color.black.opacity(0.8)))
            })
        })
        .aspectRatio(400/75, contentMode: .fit)
    }
}

struct ResultHeader_Previews: PreviewProvider {
    static let schedule: RealmCoopSchedule = RealmCoopSchedule(dummy: true)
    static var previews: some View {
        ResultHeader(schedule: schedule)
            .previewLayout(.fixed(width: 400, height: 75))
            .preferredColorScheme(.dark)
    }
}
