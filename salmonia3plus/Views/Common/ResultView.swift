//
//  ResultView.swift
//  Salmonia3+
//  
//  Created by devonly on 2022/12/08
//  Copyright © 2022 Magi Corporation. All rights reserved.
//

import Foundation
import SwiftUI
import RealmSwift
import SplatNet3

struct ResultView: View {
    let result: RealmCoopResult

    var body: some View {
        ScrollView(.vertical, showsIndicators: false, content: {
            _ResultHeader(result: result)
        })
    }
}

private struct _ResultHeader: View {
    let result: RealmCoopResult
    let dateFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateFormat = LocalizedType.Widgets_StagesYearDatetimeFormat.localized
        return formatter
    }()

    func Header() -> some View {
        HStack(content: {
            Text(dateFormatter.string(from: result.playTime))
                .font(systemName: .Splatfont2, size: 10)
                .foregroundColor(.white)
                .padding(.vertical, 3)
                .padding(.horizontal, 10)
                .background(content: {
                    Color.black
                })
            Spacer()
            Text(result.schedule.stageId)
                .font(systemName: .Splatfont2, size: 10)
                .foregroundColor(.white)
                .padding(.vertical, 3)
                .padding(.horizontal, 10)
                .background(content: {
                    Color.black
                })
        })
        .frame(maxWidth: 440)
        .padding(.top, 5)
        .padding(.leading, 5)
    }

    func WeaponView() -> some View {
        let schedule: RealmCoopSchedule = result.schedule
        return HStack(content: {
            /// ブキ画像はスペースが0
            HStack(spacing: 0, content: {
                ForEach(schedule.weaponList.indices, id: \.self, content: { index in
                    let weaponId: WeaponId = schedule.weaponList[index]
                    Image(weaponId)
                        .resizable()
                        .scaledToFit()
                        .frame(width: 25, height: 25, alignment: .center)
                })
            })
            .padding(.trailing, 15)
            Text(bundle: .CoopHistory_DangerRatio)
                .font(systemName: .Splatfont2, size: 10)
                .foregroundColor(.white.opacity(0.6))
            Text(String(format: "%d%%", (result.dangerRate * 100).intValue))
                .font(systemName: .Splatfont, size: 15)
                .foregroundColor(.white)
        })
        .padding(.horizontal, 14)
        .background(alignment: .center, content: {
            RoundedRectangle(cornerRadius: 20)
                .fill(SPColor.SplatNet3.SPDark)
                .frame(height: 30, alignment: .center)
        })
    }

    var body: some View {
        Image(result.schedule.stageId, size: .Header)
            .resizable()
            .scaledToFit()
            .overlay(alignment: .center, content: {
                Text(bundle: result.isClear ? .CoopHistory_Clear : .CoopHistory_Failure)
                    .font(systemName: .Splatfont, size: 25)
                    .foregroundColor(SPColor.SplatNet3.SPSalmonGreen)
            })
            .overlay(alignment: .top, content: {
                Header()
            })
            .padding(.bottom, 15)
            .overlay(alignment: .bottom, content: {
                WeaponView()
            })
    }
}

struct ResultView_Previews: PreviewProvider  {
    static let result: RealmCoopResult = RealmCoopResult.preview

    static var previews: some View {
        ResultView(result: result)
    }
}

struct ScheduleView_Previews: PreviewProvider {
    static let result: RealmCoopResult = RealmCoopResult.preview

    static var previews: some View {
        _ResultHeader(result: result)
    }
}

extension Decimal128 {
    var intValue: Int {
        Int(truncating: NSDecimalNumber(decimal: self.decimalValue))
    }

    var dobleValue: Double {
        Double(truncating: NSDecimalNumber(decimal: self.decimalValue))
    }
}
