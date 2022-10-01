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
            LazyVGrid(columns: Array(repeating: .init(.flexible()), count: 2), content: {
                let scale: CGFloat = geometry.width / 400
                ResultScoreScale(result: result)
                    .environment(\.scale, scale)
                ResultScorePoint(result: result)
                    .environment(\.scale, scale)
            })
        })
        .aspectRatio(400/70, contentMode: .fit)
    }
}

private struct ResultScorePoint: View {
    @Environment(\.scale) var scale: CGFloat
    let result: RealmCoopResult

    var body: some View {
        VStack(alignment: .trailing, spacing: 8, content: {
            HStack(alignment: .center, spacing: nil, content: {
                Text(localizedText: "JOB_RESULT_POINTS")
                    .foregroundColor(.gray)
                    .font(systemName: .Splatfont2, size: 12)
                Spacer()
                if let kumaPoint: Int = result.kumaPoint {
                    Text(String(format: "%dp", kumaPoint))
                        .foregroundColor(.white)
                        .frame(height: 18)
                } else {
                    Text(String(format: "-"))
                        .foregroundColor(.white)
                        .frame(height: 18)
                }
            })
            .font(systemName: .Splatfont2, size: 16)
            .frame(height: 18)
            Divider()
            HStack(alignment: .center, spacing: 1, content: {
                if let score = result.jobScore,
                   let rate = result.jobRate,
                   let bonus = result.jobBonus {
                    Spacer()
                    VStack(alignment: .center, spacing: 0, content: {
                        Text(String(format: "%d", score))
                            .frame(height: 18)
                        Text(localizedText: "JOB_RESULT_SCORE")
                            .foregroundColor(.gray)
                            .font(systemName: .Splatfont2, size: 10)
                            .frame(height: 10)
                    })
                    Text("x")
                        .padding(.horizontal, 4)
                    VStack(alignment: .center, spacing: 0, content: {
                        Text(String(format: "%.2f", rate))
                            .frame(height: 18)
                        Text(localizedText: "JOB_RESULT_RATE")
                            .foregroundColor(.gray)
                            .font(systemName: .Splatfont2, size: 10)
                            .frame(height: 10)
                    })
                    Text("+")
                        .padding(.horizontal, 4)
                    VStack(alignment: .center, spacing: 0, content: {
                        Text(String(format: "%d", bonus))
                            .frame(height: 18)
                        Text(localizedText: "JOB_RESULT_BONUS")
                            .foregroundColor(.gray)
                            .font(systemName: .Splatfont2, size: 10)
                            .frame(height: 10)
                    })
                }
            })
            .foregroundColor(.white)
            .font(systemName: .Splatfont2, size: 16)
        })
        .scaleEffect(scale)
        .padding(4)
        .background(RoundedRectangle(cornerRadius: 4).fill(SPColor.SplatNet3.SPBackground))
        .aspectRatio(200/70, contentMode: .fit)
    }
}

private struct ResultScoreScale: View {
    @Environment(\.scale) var scale: CGFloat
    let result: RealmCoopResult

    var body: some View {
        VStack(alignment: .leading, spacing: 4, content: {
            if let gradeId = result.grade, let gradePoint = result.gradePoint {
                HStack(content: {
                    Text(gradeId.localizedText)
                    Text("\(gradePoint)")
                    Spacer()
                })
                .foregroundColor(SPColor.SplatNet3.SPSalmonGreen)
                .frame(height: 18)
            }
            HStack(content: {
                HStack(spacing: 4, content: {
                    Image(bundle: .Golden)
                        .resizable()
                        .scaledToFit()
                        .frame(width: 20, height: 20, alignment: .center)
                    Text("x\(String(format: "%d", result.goldenIkuraNum))")
                })
                HStack(spacing: 4, content: {
                    Image(bundle: .Power)
                        .resizable()
                        .scaledToFit()
                        .frame(width: 20, height: 20, alignment: .center)
                    Text("x\(String(format: "%d", result.ikuraNum))")
                })
            })
            .foregroundColor(.white)
            .frame(height: 20)
            HStack(content: {
                ForEach(ScaleType.allCases) { scaleId in
                    HStack(spacing: 4, content: {
                        Image(bundle: scaleId)
                            .resizable()
                            .scaledToFit()
                            .frame(width: 20, height: 20, alignment: .center)
                        if let count: Int = result.scale[scaleId.rawValue] {
                            Text("x\(count)")
                        } else {
                            Text("-")
                        }
                    })
                }
            })
            .foregroundColor(.white)
            .frame(height: 20)
        })
        .font(systemName: .Splatfont2, size: 14)
        .scaleEffect(scale)
        .aspectRatio(200/70, contentMode: .fit)
        .padding(4)
        .background(RoundedRectangle(cornerRadius: 4).fill(SPColor.SplatNet3.SPBackground))
    }
}

extension ScaleType: Identifiable {
    public var id: Int { rawValue }
}

struct ResultScore_Previews: PreviewProvider {
    static let result: RealmCoopResult = RealmCoopResult(dummy: true)
    static let schedule: RealmCoopSchedule = RealmCoopSchedule(dummy: true)
    static var previews: some View {
        ResultScore(result: result)
            .preferredColorScheme(.dark)
    }
}
