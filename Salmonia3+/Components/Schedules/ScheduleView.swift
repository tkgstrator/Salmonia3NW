//
//  ScheduleView.swift
//  Salmonia3+
//
//  Created by devonly on 2022/09/17.
//

import SwiftUI

struct ScheduleView: View {
    let schedule: RealmCoopSchedule

    var body: some View {
        GeometryReader(content: { geometry in
            let scale: CGFloat = geometry.width / 270
            VStack(alignment: .leading, content: {
                Text(schedule.stageId.localizedText)
                    .font(systemName: .Splatfont2, size: 15 * scale)
                    .frame(height: 15)
                Spacer()
                HStack(content: {
                    Spacer()
                    ScheduleWeapon(schedule: schedule)
                })
            })
        })
        .aspectRatio(400/80, contentMode: .fit)
    }
}

struct ScheduleView_Previews: PreviewProvider {
    static let schedule: RealmCoopSchedule = RealmCoopSchedule(dummy: true)
    static var previews: some View {
        ScheduleView(schedule: schedule)
            .previewLayout(.fixed(width: 400, height: 80))
    }
}
