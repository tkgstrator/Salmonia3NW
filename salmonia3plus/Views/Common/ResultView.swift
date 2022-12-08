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
            _ResultHeader()
            _ResultStaus()
            _ResultWave()
        })
        .navigationBarTitleDisplayMode(.inline)
        .environment(\.coopResult, result)
    }
}

private struct _ResultHeader: View {
    @Environment(\.coopResult) var result
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

private struct _ResultStaus: View {
    @Environment(\.coopResult) var result

    func ResultStatus() -> some View {
        VStack(alignment: .leading, spacing: 0, content: {
            HStack(spacing: 4, content: {
                Text(result.grade)
                Text(result.gradePoint)
            })
            .font(systemName: .Splatfont2, size: 12)
            .foregroundColor(SPColor.SplatNet3.SPSalmonGreen)
            .padding(.bottom, 5)
            ZStack(alignment: .leading, content: {
                RoundedRectangle(cornerRadius: 10)
                    .frame(width: 153, height: 10)
                RoundedRectangle(cornerRadius: 10)
                    .frame(width: 153 * 0.5, height: 10)
                    .foregroundColor(SPColor.SplatNet3.SPSalmonOrange)
            })
            .padding(.bottom, 10)
            HStack(alignment: .bottom, spacing: nil, content: {
                HStack(spacing: 4, content: {
                    Image(icon: .GoldenIkura)
                        .resizable()
                        .scaledToFit()
                        .frame(width: 16, height: 16)
                    Text(String(format: "x%d", result.goldenIkuraNum))
                        .font(systemName: .Splatfont2, size: 12)
                        .foregroundColor(Color.white)
                })
                HStack(spacing: 4, content: {
                    Image(icon: .Ikura)
                        .resizable()
                        .scaledToFit()
                        .frame(width: 22, height: 16)
                    Text(String(format: "x%d", result.ikuraNum))
                        .font(systemName: .Splatfont2, size: 12)
                        .foregroundColor(Color.white)
                })
            })
            .padding(.bottom, 5)
            HStack(alignment: .bottom, spacing: nil, content: {
                ForEach(ScaleType.allCases, content: { scale in
                    HStack(spacing: 4, content: {
                        Image(scale)
                            .resizable()
                            .scaledToFit()
                            .frame(width: 16, height: 16)
                        Text(String(format: "x%d", result.scale[scale.rawValue]))
                            .font(systemName: .Splatfont2, size: 12)
                            .foregroundColor(Color.white)
                    })
                })
            })
        })
        .padding(10)
        .background(content: {
            Color.black.opacity(0.7)
        })
        .frame(width: 173, height: 96.5)
        .cornerRadius(10, corners: .allCorners)
    }

    func GridStatus() -> some View {
        HStack(spacing: 0, content: {
            VStack(content: {
                Text(String(format: "%d", result.jobScore))
                    .font(systemName: .Splatfont2, size: 15)
                    .foregroundColor(Color.white)
                Text(bundle: .CoopHistory_Score)
                    .font(systemName: .Splatfont2, size: 10)
                    .foregroundColor(SPColor.SplatNet2.SPWhite)
            })
            .frame(maxWidth: .infinity)
            Text("x")
                .font(systemName: .Splatfont2, size: 15)
                .foregroundColor(SPColor.SplatNet2.SPWhite)
            VStack(content: {
                Text(String(format: "%@", result.jobRate))
                    .font(systemName: .Splatfont2, size: 15)
                    .foregroundColor(Color.white)
                Text(bundle: .CoopHistory_JobRatio)
                    .font(systemName: .Splatfont2, size: 10)
                    .foregroundColor(SPColor.SplatNet2.SPWhite)
            })
            .frame(maxWidth: .infinity)
            Text("+")
                .font(systemName: .Splatfont2, size: 15)
                .foregroundColor(SPColor.SplatNet2.SPWhite)
            VStack(content: {
                Text(String(format: "%d", result.jobBonus))
                    .font(systemName: .Splatfont2, size: 15)
                    .foregroundColor(Color.white)
                Text(bundle: .CoopHistory_Bonus)
                    .font(systemName: .Splatfont2, size: 10)
                    .foregroundColor(SPColor.SplatNet2.SPWhite)
            })
            .frame(maxWidth: .infinity)
        })
    }

    func PointStatus() -> some View {
        VStack(alignment: .center, spacing: 1, content: {
            HStack(content: {
                Text(bundle: .CoopHistory_JobPoint)
                    .font(systemName: .Splatfont2, size: 12)
                    .foregroundColor(SPColor.SplatNet2.SPWhite)
                Spacer()
                Text(String(format: "%dp", result.kumaPoint))
                    .font(systemName: .Splatfont2, size: 18)
                    .foregroundColor(Color.white)
            })
            .padding(10)
            .frame(height: 47.5)
            .background(content: {
                Color.black.opacity(0.7)
            })
            .cornerRadius(10, corners: [.topLeft, .topRight])
            VStack(content: {
                GridStatus()
            })
            .padding(10)
            .frame(width: 173, height: 48)
            .background(content: {
                Color.black.opacity(0.7)
            })
            .cornerRadius(10, corners: [.bottomLeft, .bottomRight])
        })
        .frame(width: 173)
    }

    var body: some View {
        HStack(content: {
            ResultStatus()
            PointStatus()
        })
    }
}

private struct _ResultWave: View {
//    @Environment(\.coopResult) var result: RealmCoopResult
    let waves: [RealmCoopWave] = RealmCoopWave.previews

    var body: some View {
        HStack(spacing: 1, content: {
            ForEach(waves, content: { wave in
                VStack(spacing: 0, content: {
                    Text(String(format: "WAVE %d", wave.id))
                        .font(systemName: .Splatfont2, size: 13)
                        .foregroundColor(Color.black)
                        .padding(.top, 7)
                        .padding(.bottom, 4)
                        .frame(height: 24)
                    if let goldenIkuraNum = wave.goldenIkuraNum, let quotaNum = wave.quotaNum {
                        Text(String(format: "%d/%d", goldenIkuraNum, quotaNum))
                            .font(systemName: .Splatfont2, size: 17)
                            .foregroundColor(Color.white)
                            .frame(height: 25)
                            .frame(maxWidth: .infinity)
                            .background(content: {
                                Color.black.opacity(0.8)
                            })
                    }
                    Spacer()
                    HStack(spacing: 4, content: {
                        Image(icon: .GoldenIkura)
                            .resizable()
                            .scaledToFit()
                            .frame(width: 16, height: 16, alignment: .center)
                        Text(String(format: "x%d", wave.goldenIkuraPopNum))
                            .font(systemName: .Splatfont2, size: 11)
                            .foregroundColor(Color.black.opacity(0.6))
                    })
                    Text(bundle: .CoopHistory_Available)
                        .font(systemName: .Splatfont2, size: 9)
                        .foregroundColor(Color.black.opacity(0.6))
                        .padding(.bottom, 5)
                })
                .frame(width: 100, height: 135)
                .background(content: {
                    SPColor.SplatNet3.SPYellow
                })
            })
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
        _ResultHeader()
            .environment(\.coopResult, result)
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

extension String {
    init(format: String, _ arguments: CVarArg?) {
        if let arguments = arguments {
            self.init(format: format, arguments)
        } else {
            self.init("-")
        }
    }
}

struct RoundedCorner: Shape {
    var radius: CGFloat = .infinity
    var corners: UIRectCorner = .allCorners

    func path(in rect: CGRect) -> Path {
        let path = UIBezierPath(roundedRect: rect, byRoundingCorners: corners, cornerRadii: CGSize(width: radius, height: radius))
        return Path(path.cgPath)
    }
}

extension View {
    func cornerRadius(_ radius: CGFloat, corners: UIRectCorner) -> some View {
        clipShape(RoundedCorner(radius: radius, corners: corners))
    }
}

extension Text {
//    init<T: BinaryInteger>(_ value: T?) {
//        if let value = value {
//            self.init(verbatim: "\(value)")
//        } else {
//            self.init("-")
//        }
//    }
}
