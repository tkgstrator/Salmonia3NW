//
//  ScheduleView.swift
//  Salmonia3+
//
//  Created by devonly on 2022/09/17.
//

import SwiftUI
import SplatNet3

struct ScheduleView: View {
    let schedule: RealmCoopSchedule

    var body: some View {
        switch schedule.results.isEmpty {
        case true:
            EmptyView()
        case false:
            if let startTime = schedule.startTime {
                NavigationLinker(destination: {
                    ScheduleStatsView()
                        .environment(\.startTime, startTime)
                }, label: {
                    ScheduleViewElement(schedule: schedule)
                })
            } else {
                ScheduleViewElement(schedule: schedule)
            }
        }
    }
}

private struct ScheduleViewElement: View {
    let schedule: RealmCoopSchedule

    let dateFormatter: DateFormatter = {
        let formatter: DateFormatter = DateFormatter()
        formatter.timeZone = TimeZone.current
        formatter.dateFormat = LocalizedType.Widgets_StagesYearDatetimeFormat.localized
        return formatter
    }()

    var body: some View {
        ZStack(alignment: .center, content: {
            Color.black
            VStack(alignment: .leading, spacing: 0, content: {
                HStack(alignment: .center, spacing: 0, content: {
                    Text(schedule.stageId.localizedText)
                    Spacer()
                    if let startTime = schedule.startTime {
                        Text(dateFormatter.string(from: startTime))
                    }
                })
                .font(systemName: .Splatfont2, size: 14)
                HStack(alignment: .center, spacing: 0, content: {
                    if let gradeId = schedule.grade, let gradePoint = schedule.gradePoint {
                        Text(String(format: "%@ %d", gradeId.localizedText, gradePoint))
                    }
                    Spacer()
                    ForEach(schedule.weaponList.indices, id: \.self) { index in
                        let weaponId: WeaponType = schedule.weaponList[index]
                        Image(bundle: weaponId)
                            .resizable()
                            .scaledToFit()
                            .frame(width: 30, height: 30, alignment: .center)
                    }
                })
                .font(systemName: .Splatfont2, size: 14)
            })
            .padding(.horizontal)
            .padding(.bottom, 8)
            .padding(.top, 4)
        })
        .foregroundColor(.white)
    }
}

fileprivate extension RealmCoopSchedule {
    var grade: GradeType? {
        let grade: Int? = self.results.max(ofProperty: "grade")
        return GradeType(id: grade)
    }

    var gradePoint: Int? {
        let gradeIdMax: GradeType? = self.grade
        let gradePointMax: Int? = {
            guard let gradeIdMax = gradeIdMax else {
                return nil
            }
            return results.filter("grade=%@", gradeIdMax).max(ofProperty: "gradePoint")
        }()
        return gradePointMax
    }

    func ikuraNum() -> Int? {
        self.results.max(ofProperty: "ikuraNum")
    }

    func goldenIkuraNum() -> Int? {
        self.results.max(ofProperty: "goldenIkuraNum")
    }
}

struct ScheduleView_Previews: PreviewProvider {
    static let schedule: RealmCoopSchedule = RealmCoopSchedule(dummy: true)
    static var previews: some View {
        ScheduleView(schedule: schedule)
            .previewLayout(.fixed(width: 450, height: 60))
        ScheduleView(schedule: schedule)
            .previewLayout(.fixed(width: 400, height: 60))
        ScheduleView(schedule: schedule)
            .previewLayout(.fixed(width: 375, height: 60))
    }
}
