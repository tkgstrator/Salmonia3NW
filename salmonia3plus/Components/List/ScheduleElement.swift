//
//  ScheduleElement.swift
//  Salmonia3+
//  
//  Created by devonly on 2022/12/03
//  Copyright © 2022 Magi Corporation. All rights reserved.
//

import SwiftUI
import SplatNet3

struct ScheduleElement: View {
    let schedule: RealmCoopSchedule

    var body: some View {
        if let startTime = schedule.startTime {
            NavigationLinker(destination: {
                EmptyView()
            }, label: {
                _ScheduleElement(schedule: schedule)
            })
            .listRowInsets(EdgeInsets())
            .listRowSeparator(.hidden)
        } else {
            _ScheduleElement(schedule: schedule)
                .listRowInsets(EdgeInsets())
                .listRowSeparator(.hidden)
        }
    }
}

private struct _ScheduleElement: View {
    let schedule: RealmCoopSchedule
    let backgroundColor: Color
    let dateFormatter: DateFormatter = {
        let formatter: DateFormatter = DateFormatter()
        formatter.timeZone = TimeZone.current
        formatter.dateFormat = LocalizedType.Widgets_StagesYearDatetimeFormat.localized
        return formatter
    }()

    init(schedule: RealmCoopSchedule) {
        self.schedule = schedule
        self.backgroundColor = {
            switch schedule.scheduleType {
            case .PLAYED:
                return SPColor.SplatNet3.SPSalmonOrangeDarker
            case .UNPLAYED:
                return SPColor.SplatNet3.SPBackground
            case .FUTURE:
                return SPColor.SplatNet3.SPYellow.opacity(0.7)
            case .CURRENT:
                return SPColor.SplatNet3.SPBlue.opacity(0.7)
            }
        }()
    }

    func StageName() -> some View {
        Text(schedule.stageId)
            .font(systemName: .Splatfont2, size: 10)
            .foregroundColor(.white)
            .padding([.vertical], 2)
            .padding(.horizontal, 4)
            .background(Color.black)
    }

    func StartTime() -> some View {
        if let startTime = schedule.startTime {
            return Text(dateFormatter.string(from: startTime))
                .font(systemName: .Splatfont2, size: 10)
                .foregroundColor(.white)
                .padding([.vertical], 2)
                .padding(.horizontal, 4)
                .background(Color.black)
        }
        return Text("-")
            .font(systemName: .Splatfont2, size: 10)
            .foregroundColor(.white)
            .padding([.vertical], 2)
            .padding(.horizontal, 4)
            .background(Color.black)
    }

    func WeaponList() -> some View {
        LazyVGrid(columns: Array(repeating: .init(.fixed(28.17), spacing: 0), count: 4), content: {
            ForEach(schedule.weaponList.indices, id: \.self, content: { index in
                let weaponId: WeaponId = schedule.weaponList[index]
                Image(weaponId)
                    .resizable()
                    .scaledToFit()
            })
        })
        .frame(width: 30 * 4)
        .padding(4)
        .background(RoundedRectangle(cornerRadius: 18).fill(Color.black))
        .padding(4)
    }

    func GradePoint() -> some View {
        HStack(spacing: 4, content: {
            Text(schedule.maxGradeId)
            Text(schedule.maxGradePoint)
        })
        .font(systemName: .Splatfont2, size: 10)
        .foregroundColor(.white)
        .padding([.vertical], 2)
        .padding(.horizontal, 4)
        .background(Color.black)
    }

    func GradeBadge() -> some View {
        guard let maxGradePoint = schedule.maxGradePoint else {
            return EmptyView()
                .asAnyView()
        }
        if maxGradePoint < 200 {
            return EmptyView()
                .asAnyView()
        }
        let offset: Int = maxGradePoint == 999 ? 3 : (maxGradePoint - 200) / 200
        guard let badgeId: BadgeId = BadgeId(rawValue: 5000000 + schedule.stageId.rawValue * 10 + offset) else {
            return EmptyView()
                .asAnyView()
        }
        return Image(bundle: badgeId)
            .resizable()
            .scaledToFit()
            .frame(width: 40, height: 40, alignment: .center)
            .asAnyView()
    }

    var body: some View {
        HStack(spacing: 0, content: {
            Image(schedule.stageId)
                .resizable()
                .scaledToFill()
                .frame(width: 136, height: 64)
                .clipped()
                .overlay(alignment: .bottom, content: {
                    StageName()
                })
                .overlay(alignment: .topLeading, content: {
                    GradePoint()
                })
            Rectangle()
                .fill(backgroundColor)
                .overlay(alignment: .bottomLeading, content: {
                    GradeBadge()
                })
                .overlay(alignment: .topTrailing, content: {
                    StartTime()
                })
                .overlay(alignment: .bottomTrailing, content: {
                    WeaponList()
                })
        })
        .padding(.bottom, 2)
    }
}

private enum ScheduleType: Int, CaseIterable, Codable, Identifiable {
    var id: Int { rawValue }
    case UNPLAYED
    case CURRENT
    case FUTURE
    case PLAYED
}

extension RealmCoopSchedule {
    var maxGradeId: GradeId? {
        guard let rawValue: Int = self.results.max(ofProperty: "gradeId") else {
            return nil
        }
        return GradeId(rawValue: rawValue)
    }

    var maxGradePoint: Int? {
        guard let maxGradeId: GradeId = self.maxGradeId else {
            return nil
        }
        return results.filter("gradeId=%@", maxGradeId).max(ofProperty: "gradePoint")
    }

    fileprivate var scheduleType: ScheduleType {
        if let startTime = self.startTime, let endTime = self.endTime {
            let currentTime: Date = Date()
            /// 開催中
            if currentTime >= startTime && currentTime <= endTime {
                return .CURRENT
            }
            /// 開催済み
            if currentTime >= startTime {
                if self.results.isEmpty {
                    return .UNPLAYED
                } else {
                    return .PLAYED
                }
            }
            /// 未開催
            return .FUTURE
        }
        return .UNPLAYED
    }
}

struct ScheduleElement_Previews: PreviewProvider {
    @Environment(\.isPreview) var isPreview
    static let schedule: RealmCoopSchedule = RealmCoopSchedule.preview

    static var previews: some View {
        List(content: {
            ScheduleElement(schedule: schedule)
        })
        .listStyle(.plain)
    }
}
