//
//  ResultScore.swift
//  Salmonia3+
//
//  Created by devonly on 2022/09/17.
//

import SwiftUI
import SplatNet3

struct ResultScore: View {
    let result: RealmCoopResult

    var body: some View {
        GeometryReader(content: { geometry in
            HStack(alignment: .center, spacing: 0, content: {
                ResultScore_1(result: result, geometry: geometry)
                ResultScore_2(result: result, geometry: geometry)
            })
        })
        .aspectRatio(400/70, contentMode: .fit)
    }
}

private struct ResultScore_2: View {
    let result: RealmCoopResult
    let geometry: GeometryProxy

    var body: some View {
        let scale: CGFloat = geometry.width * 0.5 / 200
        let width: CGFloat = geometry.width * 0.5
        let height: CGFloat = geometry.width / 200 * 70 * 0.5
        VStack(alignment: .center, spacing: nil, content: {
            HStack(alignment: .center, spacing: nil, content: {
                Spacer()
                if let kumaPoint: Int = result.kumaPoint {
                    Text(String(format: "%dp", kumaPoint))
                        .font(systemName: .Splatfont2, size: 18 * scale)
                        .frame(height: 16 * scale)
                } else {
                    Text(String(format: "-"))
                }
            })
            Divider()
            HStack(alignment: .center, spacing: 1 * scale, content: {
                if let score = result.jobScore,
                   let rate = result.jobRate,
                   let bonus = result.jobBonus {
                    Spacer()
                    Text(String(format: "%d", score))
                    Text("x")
                        .padding(.horizontal, 4)
                    Text(String(format: "%.2f", rate))
                    Text("+")
                        .padding(.horizontal, 4)
                    Text(String(format: "%d", bonus))
                }
            })
            .font(systemName: .Splatfont2, size: 16 * scale)
            .frame(height: 20 * scale)
        })
        .frame(width: width, height: height, alignment: .center)
        .aspectRatio(200/70, contentMode: .fit)
    }
}

private struct ResultScore_1: View {
    let result: RealmCoopResult
    let geometry: GeometryProxy

    var body: some View {
        let scale: CGFloat = geometry.width * 0.5 / 200
        let width: CGFloat = geometry.width * 0.5
        let height: CGFloat = geometry.width / 200 * 70 * 0.5

        VStack(alignment: .leading, spacing: nil, content: {
            if let grade = result.grade, let gradePoint = result.gradePoint {
                HStack(spacing: nil, content: {
                    Text(grade.localizedText)
                        .font(systemName: .Splatfont2, size: 16 * scale)
                        .frame(height: 16 * scale)
                    Text("\(gradePoint)")
                        .font(systemName: .Splatfont2, size: 16 * scale)
                        .frame(height: 16 * scale)
                    Spacer()
                })
                .frame(width: width)
                ZStack(alignment: .leading, content: {
                    let maxValue: CGFloat = grade == .Eggsecutive_VP ? 999 : 100
                    RoundedRectangle(cornerRadius: 10)
                        .fill(Color.primary.opacity(0.3))
                        .frame(width: (width - 10 * scale), height: 8 * scale, alignment: .center)
                    RoundedRectangle(cornerRadius: 10)
                        .fill(SPColor.Theme.SPOrange)
                        .frame(width: (width - 10 * scale) * CGFloat(gradePoint) / maxValue, height: 8 * scale, alignment: .center)
                })
            }
            HStack(spacing: 0 * scale, content: {
                ForEach(result.scale.indices, id: \.self) { index in
                    let width: CGFloat = (geometry.width - 20) * 0.06
                    if let scaleType: ScaleType = ScaleType(rawValue: index) {
                        Group(content: {
                            Image(bundle: scaleType)
                                .resizable()
                                .frame(width: width, height: width, alignment: .center)
                            if let scaleCount: Int = result.scale[index] {
                                Text("\(scaleCount)")
                                    .font(systemName: .Splatfont2, size: 16 * scale)
                                    .frame(width: 30 * scale, height: 16 * scale)
                            } else {
                                Text("-")
                                    .font(systemName: .Splatfont2, size: 16 * scale)
                                    .frame(height: 30 * scale)
                            }
                        })
                        .frame(width: 28 * scale)
                    }
                }
                Spacer()
            })
            .frame(width: width, height: 20 * scale)
        })
        .frame(width: width, height: height, alignment: .center)
        .aspectRatio(200/70, contentMode: .fit)
    }
}

struct ResultScore_Previews: PreviewProvider {
    static let result: RealmCoopResult = RealmCoopResult(dummy: true)
    static let schedule: RealmCoopSchedule = RealmCoopSchedule(dummy: true)
    static var previews: some View {
//        ResultDetailView(result: result, schedule: schedule)
//            .previewLayout(.fixed(width: 400, height: 800))
//            .preferredColorScheme(.dark)
        ResultScore(result: result)
            .previewLayout(.fixed(width: 400, height: 70))
            .preferredColorScheme(.dark)
    }
}
