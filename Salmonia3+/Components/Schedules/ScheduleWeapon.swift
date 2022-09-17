//
//  ScheduleWeapon.swift
//  Salmonia3+
//
//  Created by devonly on 2022/09/17.
//

import SwiftUI
import SplatNet3

struct ScheduleWeapon: View {
    let schedule: RealmCoopSchedule

    var body: some View {
        GeometryReader(content: { geometry in
            let scale: CGFloat = geometry.width / 172
            LazyVGrid(columns: Array(repeating: .init(.flexible(), spacing: 2, alignment: .trailing), count: 4), alignment: .trailing, spacing: 0, content: {
                ForEach(schedule.weaponList.indices, id: \.self) { index in
                    let weapon: WeaponType = schedule.weaponList[index]
                    Image(bundle: weapon)
                        .resizable()
                        .scaledToFit()
                        .padding(2 * scale)
                        .background(Circle().fill(Color.black.opacity(0.9)))
                }
            })
        })
        .aspectRatio(172/40, contentMode: .fit)
    }
}

struct ScheduleWeapon_Previews: PreviewProvider {
    static let schedule: RealmCoopSchedule = RealmCoopSchedule(dummy: true)
    static var previews: some View {
        ScheduleWeapon(schedule: schedule)
            .previewLayout(.fixed(width: 400, height: 60))
            .preferredColorScheme(.dark)
    }
}
