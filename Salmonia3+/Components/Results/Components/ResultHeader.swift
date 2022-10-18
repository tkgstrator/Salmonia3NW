//
//  ResultHeader.swift
//  Salmonia3+
//
//  Created by devonly on 2022/09/16.
//

import SwiftUI
import RealmSwift
import SplatNet3
import CryptoKit

struct ResultHeader: View {
    @State private var scale: CGFloat = 1.0
    let schedule: RealmCoopSchedule
    let result: RealmCoopResult

    init(result: RealmCoopResult) {
        self.schedule = result.schedule
        self.result = result
    }

    private init(result: RealmCoopResult, schedule: RealmCoopSchedule) {
        self.schedule = schedule
        self.result = result
    }

    let dateFormatter: DateFormatter = {
        let formatter: DateFormatter = DateFormatter()
        formatter.timeZone = TimeZone.current
        formatter.dateFormat = LocalizedText.Widgets_StagesYearDatetimeFormat.localized
        return formatter
    }()

    var body: some View {
        ZStack(alignment: .bottom, content: {
            ZStack(alignment: .center, content: {
                Rectangle()
                    .frame(height: 75)
                    .overlay(Image(bundle: schedule.stageId).resizable().scaledToFill(), alignment: .center)
                    .clipped()
                ZStack(alignment: .center, content: {
                    Text(bundle: result.isClear ? .CoopHistory_Clear : .CoopHistory_Failure)
                        .foregroundColor(SPColor.SplatNet3.SPSalmonGreen)
                        .font(systemName: .Splatfont, size: 25)
                        .shadow(color: .black, radius: 0, x: 1, y: 1)
                    HStack(alignment: .top, spacing: nil, content: {
                        Text(String(format: "%@", dateFormatter.string(from: result.playTime)))
                            .foregroundColor(Color(hex: "dbdbdb"))
                            .font(systemName: .Splatfont2, size: 10)
                            .padding(.horizontal, 5)
                            .padding(.vertical, 3)
                            .background(Color.black)
                        Spacer()
                        VStack(alignment: .trailing, spacing: 0, content: {
                            Text(schedule.stageId.localizedText)
                                .foregroundColor(Color.white)
                                .font(systemName: .Splatfont2, size: 10)
                                .padding(.horizontal, 10)
                                .padding(.vertical, 3)
                                .background(Color.black)
                            Image(bundle: .SakelienGiant)
                                .resizable()
                                .renderingMode(.template)
                                .scaledToFit()
                                .foregroundColor(Color.black)
                                .rotation3DEffect(.degrees(180), axis: (x: 0, y: 1, z: 0))
                        })
                    })
                    .frame(maxWidth: 440)
                    .padding(.horizontal, 5)
                })
            })
            .frame(height: 75)
            .padding(.bottom, 15)
            ResultWeapon(schedule: schedule, result: result)
        })
        .padding(.bottom, 15)
    }
}

private struct ResultWeapon: View {
    let schedule: RealmCoopSchedule
    let result: RealmCoopResult

    var body: some View {
        LazyHStack(alignment: .center, spacing: 0, content: {
            LazyVGrid(columns: Array(repeating: .init(.fixed(25), spacing: 0), count: 4), content: {
                ForEach(schedule.weaponList.indices, id: \.self) { index in
                    let weaponId: WeaponType = schedule.weaponList[index]
                    Image(bundle: weaponId)
                        .resizable()
                        .scaledToFit()
                        .frame(width: 25, height: 25, alignment: .center)
                }
            })
            .padding(.trailing, 15)
            Text(bundle: .CoopHistory_DangerRatio)
                .foregroundColor(Color.white.opacity(0.6))
                .font(systemName: .Splatfont2, size: 10)
            Text(String(format: "%.1f%%", result.dangerRate * 100))
                .foregroundColor(Color.white)
                .font(systemName: .Splatfont, size: 15)
                .padding(.leading, 4)
        })
        .frame(height: 30)
        .padding(.horizontal, 14)
        .background(RoundedRectangle(cornerRadius: 14).fill(Color(hex: "240f09")))
    }
}

struct ResultHeader_Previews: PreviewProvider {
    static let result: RealmCoopResult = RealmCoopResult(dummy: true)
    static let schedule: RealmCoopSchedule = RealmCoopSchedule(dummy: true)
    static var previews: some View {
        ResultWeapon(schedule: schedule, result: result)
            .previewLayout(.fixed(width: 400, height: 100))
        ResultWeapon(schedule: schedule, result: result)
            .previewLayout(.fixed(width: 400, height: 100))
            .preferredColorScheme(.dark)
        ResultWeapon(schedule: schedule, result: result)
            .previewLayout(.fixed(width: 600, height: 100))
            .preferredColorScheme(.dark)
    }
}
