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
    let dateFormatter: DateFormatter = {
        let formatter: DateFormatter = DateFormatter()
        formatter.timeZone = TimeZone.current
        formatter.dateFormat = "MM/dd HH:mm:ss"
        return formatter
    }()

    var body: some View {
        GeometryReader(content: { geometry in
            let scale: CGFloat = geometry.width / 270
            VStack(alignment: .leading, content: {
                HStack(content: {
                    Text(schedule.stageId.localizedText)
                    Spacer()
                    if let startTime = schedule.startTime {
                        Text(dateFormatter.string(from: startTime))
                            .font(systemName: .Splatfont2, size: 12 * scale)
                    }
                })
                .font(systemName: .Splatfont2, size: 15 * scale)
                .frame(height: 15 * scale)
                Spacer()
                HStack(content: {
                    if let grade = schedule.grade, let gradePoint = schedule.gradePoint {
                        HStack(alignment: .center, spacing: 8, content: {
                            Text(grade.localizedText)
                            Text(" \(gradePoint)")
                        })
                        .font(systemName: .Splatfont2, size: 12 * scale)
                    }
                    Spacer()
                    ScheduleWeapon(schedule: schedule)
                })
            })
        })
        .aspectRatio(400/80, contentMode: .fit)
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
            .previewLayout(.fixed(width: 400, height: 80))
    }
}
