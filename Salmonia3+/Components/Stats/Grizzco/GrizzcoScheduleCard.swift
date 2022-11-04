//
//  GrizzcoScheduleCard.swift
//  Salmonia3+
//
//  Created by tkgstrator on 2022/10/19.
//

import SwiftUI
import SplatNet3

private struct GrizzcoScheduleView: View {
    let average: Grizzco.Chart.Average

    var body: some View {
        VStack(alignment: .center, spacing: 0, content: {
            Text(bundle: .StageSchedule_SuppliedWeapons)
                .font(systemName: .Splatfont2, size: 13)
                .foregroundColor(Color.white)
                .shadow(color: Color.black, radius: 0, x: 1, y: 1)
                .padding(.bottom, 8)
            LazyVGrid(columns: Array(repeating: .init(.flexible(maximum: 36)), count: 4), content: {
                ForEach(WeaponType.allCases.shuffled().prefix(4), id: \.rawValue) { weaponId in
                    Image(bundle: weaponId)
                        .resizable()
                        .scaledToFit()
                        .frame(width: 36, height: 36, alignment: .center)
                }
            })
        })
    }
}

//struct GrizzcoScheduleCard_Previews: PreviewProvider {
//    static var previews: some View {
//        GrizzcoScheduleCard()
//    }
//}
