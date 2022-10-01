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

    init(schedule: RealmCoopSchedule) {
        self.result = RealmCoopResult(dummy: true)
        self.schedule = schedule
    }

    init(result: RealmCoopResult) {
        self.result = result
        self.schedule = result.schedule
    }

    init(result: RealmCoopResult, schedule: RealmCoopSchedule) {
        self.schedule = result.schedule
        self.result = result
    }

    var body: some View {
        GeometryReader(content: { geometry in
            let width: CGFloat = geometry.width
            let height: CGFloat = geometry.height
            ZStack(content: {
                Image(bundle: schedule.stageId)
                    .resizable()
                HStack(alignment: .center, spacing: nil, content: {
                    Spacer()
                    ZStack(alignment: .bottom, content: {
                        let smellMeter: CGFloat = {
                            if let smellMeter = result.smellMeter {
                                return 1 - (CGFloat(smellMeter) / 5)
                            }
                            return 1
                        }()
                        Rectangle()
                            .fill(.black)
                        Rectangle()
                            .fill(.red.opacity(0.8))
                            .offset(x: 0, y: height * smellMeter)
                    })
                    .scaledToFit()
                    .clipped()
                    .mask(
                        Image(bundle: .SakelienGiant)
                            .resizable()
                            .scaledToFit()
                            .padding(8 * scale)
                    )
                })
                VStack(alignment: .center, spacing: 6 * scale, content: {
                    let title: String = result.isClear ? "Clear!" : "Defeat"
                    Text(title)
                        .font(systemName: .Splatfont, size: 22 * scale)
                        .frame(height: 20 * scale)
                        .shadow(color: .black, radius: 0, x: 1 * scale, y: 1 * scale)
                        .foregroundColor(.green)
                    HStack(spacing: nil, content: {
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
                        Text(String(format: "%.0f%%", result.dangerRate * 100))
                            .foregroundColor(.white)
                            .font(systemName: .Splatfont, size: 18 * scale)
                    })
                    .frame(width: min(200, geometry.width * 0.5), height: min(40, 30 * scale))
                    .background(RoundedRectangle(cornerRadius: 40 * scale).fill(Color.black.opacity(0.8)))
                })
            })
            .onChange(of: geometry.size.height, perform: { newValue in
                scale = min(1.5, newValue / 75)
            })
            .onAppear(perform: {
                scale = min(1.5, geometry.size.height / 75)
            })
        })
        .aspectRatio(400/75, contentMode: .fit)
    }
}

struct ResultHeader_Previews: PreviewProvider {
    static let result: RealmCoopResult = RealmCoopResult(dummy: true)
    static let schedule: RealmCoopSchedule = RealmCoopSchedule(dummy: true)
    static var previews: some View {
        ResultDetailView(result: result, schedule: schedule)
            .previewLayout(.fixed(width: 400, height: 800))
            .preferredColorScheme(.dark)
        ResultHeader(schedule: schedule)
            .previewLayout(.fixed(width: 400, height: 75))
            .preferredColorScheme(.dark)
    }
}
