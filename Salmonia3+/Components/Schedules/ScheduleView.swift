//
//  ScheduleView.swift
//  Salmonia3+
//
//  Created by tkgstrator on 2022/09/17.
//

import SwiftUI
import SplatNet3

struct ScheduleView: View {
    let schedule: RealmCoopSchedule

    var body: some View {
        if let startTime = schedule.startTime {
            NavigationLinker(destination: {
                ScheduleStatsView(startTime: startTime)
            }, label: {
                ScheduleViewElement(schedule: schedule)
            })
        } else {
            ScheduleViewElement(schedule: schedule)
        }
    }
}

private struct ScheduleViewElement: View {
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
            return [SPColor.SplatNet3.SPSalmonOrangeDarker, SPColor.SplatNet3.SPBackground].randomElement()!.opacity(0.7)
            if let startTime = schedule.startTime, let endTime = schedule.endTime {
                let currentTime: Date = Date()
                /// 開催中
                if currentTime >= startTime && currentTime <= endTime {
                    return SPColor.SplatNet3.SPBlue.opacity(0.7)
                }
                /// 開催済み
                if currentTime >= startTime {
                    return SPColor.SplatNet3.SPBackground
                }
                /// 未開催
                return SPColor.SplatNet3.SPYellow.opacity(0.7)
            }
            return SPColor.SplatNet3.SPBackground
        }()
    }

    func StageName() -> some View {
        Text(schedule.stageId.localizedText)
            .font(systemName: .Splatfont2, size: 10)
            .foregroundColor(.white)
            .padding([.vertical], 2)
            .padding(.horizontal, 4)
            .background(Color.black)
    }

    func GradePoint() -> some View {
        if let grade = schedule.grade, let gradePoint = schedule.gradePoint {
            return Text(String(format: "%@ %d", grade.localizedText, gradePoint))
                .font(systemName: .Splatfont2, size: 10)
                .foregroundColor(.white)
                .padding([.vertical], 2)
                .padding(.horizontal, 4)
                .background(Color.black)
        }
        return Text("- -")
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
                let weaponType: WeaponType = schedule.weaponList[index]
                Image(bundle: weaponType)
                    .resizable()
                    .scaledToFit()
            })
        })
        .frame(width: 30 * 4)
        .padding(4)
        .background(RoundedRectangle(cornerRadius: 18).fill(Color.black))
        .padding(4)
    }

    var body: some View {
        HStack(spacing: 0, content: {
            Image(bundle: schedule.stageId)
                .resizable()
                .scaledToFill()
                .frame(width: 136, height: 64)
                .clipped()
                .overlay(StageName(), alignment: .bottom)
//                .overlay(GradePoint(), alignment: .topLeading)
            Rectangle()
                .fill(backgroundColor)
                .frame(maxWidth: .infinity, height: 64, alignment: .center)
                .overlay(StartTime(), alignment: .topTrailing)
                .overlay(WeaponList(), alignment: .bottomTrailing)
        })
        .padding(.bottom, 2)
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
        ScrollView(content: {
            ForEach(Range(0...10), id: \.self) { _ in
                ScheduleViewElement(schedule: schedule)
                    .previewLayout(.fixed(width: 450, height: 60))
            }
        })
    }
}
