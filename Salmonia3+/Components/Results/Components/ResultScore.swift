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
            LazyVGrid(columns: Array(repeating: .init(.flexible(), spacing: nil), count: 2), content: {
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
        VStack(alignment: .trailing, spacing: 8 * scale, content: {
            HStack(alignment: .center, spacing: 2 * scale, content: {
                Text(bundle: .CoopHistory_JobPoint)
                    .foregroundColor(.gray)
                    .font(systemName: .Splatfont2, size: 12 * scale)
                Spacer()
                if let kumaPoint: Int = result.kumaPoint {
                    Text(String(format: "%dp", kumaPoint))
                        .foregroundColor(.white)
                        .frame(height: 18 * scale)
                } else {
                    Text(String(format: "-"))
                        .foregroundColor(.white)
                        .frame(height: 18 * scale)
                }
            })
            .font(systemName: .Splatfont2, size: 16 * scale)
            .frame(height: 18 * scale)
            Divider()
                .frame(height: 1.0 * scale)
                .background(.white)
            HStack(alignment: .top, spacing: 1 * scale, content: {
                if let score = result.jobScore,
                   let rate = result.jobRate,
                   let bonus = result.jobBonus {
                    Spacer()
                    VStack(alignment: .center, spacing: 1 * scale, content: {
                        Text(String(format: "%d", score))
                            .frame(height: 18 * scale)
                        Text(bundle: .CoopHistory_Score)
                            .foregroundColor(.gray)
                            .font(systemName: .Splatfont2, size: 10 * scale)
                            .frame(height: 10 * scale)
                    })
                    Text("x")
                        .padding(.horizontal, 4 * scale)
                        .padding(.bottom, 3 * scale)
                        .frame(height: 18 * scale, alignment: .center)
                    VStack(alignment: .center, spacing: 1 * scale, content: {
                        Text(String(format: "%.2f", rate))
                            .frame(height: 18 * scale)
                        Text(bundle: .CoopHistory_JobRatio)
                            .foregroundColor(.gray)
                            .font(systemName: .Splatfont2, size: 10 * scale)
                            .frame(height: 10 * scale)
                    })
                    Text("+")
                        .padding(.horizontal, 4 * scale)
                        .frame(height: 18 * scale, alignment: .center)
                    VStack(alignment: .center, spacing: 1 * scale, content: {
                        Text(String(format: "%d", bonus))
                            .frame(height: 18 * scale)
                        Text(bundle: .CoopHistory_Bonus)
                            .foregroundColor(.gray)
                            .font(systemName: .Splatfont2, size: 10 * scale)
                            .frame(height: 10 * scale)
                    })
                }
            })
            .frame(height: 28 * scale)
            .foregroundColor(.white)
            .font(systemName: .Splatfont2, size: 16 * scale)
        })
        .padding(.top, 4 * scale)
        .padding(.horizontal, 10 * scale)
        .padding(.bottom, 4 * scale)
        .frame(height: 70 * scale)
        .aspectRatio(200/70, contentMode: .fit)
        .background(RoundedRectangle(cornerRadius: 4).fill(SPColor.SplatNet3.SPBackground).overlay(Image(bundle: .WAVE_BACKGROUND).resizable().scaledToFill()).clipped())
    }
}

private struct ResultScoreScale: View {
    @Environment(\.scale) var scale: CGFloat
    let result: RealmCoopResult

    var body: some View {
        VStack(alignment: .leading, spacing: 4 * scale, content: {
            if let gradeId = result.grade, let gradePoint = result.gradePoint {
                HStack(content: {
                    Text(gradeId.localizedText)
                    Text("\(gradePoint)")
                    Spacer()
                })
                .foregroundColor(SPColor.SplatNet3.SPSalmonGreen)
                .frame(height: 18 * scale)
            } else {
                HStack(content: {
                    Spacer()
                })
                .frame(height: 18 * scale)
            }
            HStack(content: {
                HStack(spacing: 4 * scale, content: {
                    Image(bundle: .Golden)
                        .resizable()
                        .scaledToFit()
                        .frame(width: 18 * scale, height: 18 * scale, alignment: .center)
                    Text("x\(String(format: "%d", result.goldenIkuraNum))")
                })
                HStack(spacing: 4 * scale, content: {
                    Image(bundle: .Power)
                        .resizable()
                        .scaledToFit()
                        .frame(width: 18 * scale, height: 18 * scale, alignment: .center)
                    Text("x\(String(format: "%d", result.ikuraNum))")
                })
            })
            .foregroundColor(.white)
            .frame(height: 20 * scale)
            HStack(content: {
                ForEach(ScaleType.allCases) { scaleId in
                    HStack(spacing: 4 * scale, content: {
                        Image(bundle: scaleId)
                            .resizable()
                            .scaledToFit()
                            .frame(width: 18 * scale, height: 18 * scale, alignment: .center)
                        if let count: Int = result.scale[scaleId.rawValue] {
                            Text("x\(count)")
                                .frame(minWidth: 24 * scale)
                        } else {
                            Text("-")
                                .frame(minWidth: 24 * scale)
                        }
                    })
                }
            })
            .foregroundColor(.white)
            .frame(height: 20 * scale)
        })
        .font(systemName: .Splatfont2, size: 14 * scale)
        .padding(.top, 4 * scale)
        .padding(.horizontal, 10 * scale)
        .padding(.bottom, 4 * scale)
        .frame(height: 70 * scale)
        .aspectRatio(200/70, contentMode: .fit)
        .background(RoundedRectangle(cornerRadius: 4).fill(SPColor.SplatNet3.SPBackground).overlay(Image(bundle: .WAVE_BACKGROUND).resizable().scaledToFill()).clipped())
    }
}

extension ScaleType: Identifiable {
    public var id: Int { rawValue }
}

struct ResultScore_Previews: PreviewProvider {
    static let result: RealmCoopResult = RealmCoopResult(dummy: true)
    static let schedule: RealmCoopSchedule = RealmCoopSchedule(dummy: true)
    static var previews: some View {
        ResultScorePoint(result: result)
            .environment(\.scale, 1.0)
            .preferredColorScheme(.dark)
            .previewLayout(.fixed(width: 200, height: 70))
        ResultScorePoint(result: result)
            .environment(\.scale, 0.8)
            .preferredColorScheme(.dark)
            .previewLayout(.fixed(width: 160, height: 56))
        ResultScore(result: result)
            .preferredColorScheme(.dark)
            .previewLayout(.fixed(width: 400, height: 200))
        ResultScore(result: result)
            .preferredColorScheme(.dark)
            .previewLayout(.fixed(width: 360, height: 180))
    }
}
