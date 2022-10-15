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
        LazyVGrid(columns: Array(repeating: .init(.flexible(), spacing: nil), count: 2), content: {
            ResultScoreScale(result: result)
            ResultScorePoint(result: result)
        })
        .padding(.horizontal, 10)
        .padding(.bottom, 15)
    }
}

private struct ResultScorePoint: View {
    @Environment(\.scale) var scale: CGFloat
    let result: RealmCoopResult

    var body: some View {
        ZStack(alignment: .center, content: {
            RoundedRectangle(cornerRadius: 10)
                .fill(Color.black.opacity(0.7))
            VStack(spacing: 2, content: {
                HStack(spacing: nil, content: {
                    Text(bundle: .CoopHistory_JobPoint)
                        .font(systemName: .Splatfont2, size: 12)
                    Spacer()
                    Text(String(format: "%dp", result.kumaPoint))
                        .font(systemName: .Splatfont2, size: 19)
                })
                .padding(8)
                .frame(height: 47.5)
                HStack(spacing: 4, content: {
                    VStack(alignment: .center, spacing: 0, content: {
                        Text(String(format: "%d", result.jobScore))
                            .font(systemName: .Splatfont2, size: 15)
                        Text(bundle: .CoopHistory_Score)
                            .font(systemName: .Splatfont2, size: 10)
                            .foregroundColor(.white.opacity(0.6))
                    })
                    Text("x")
                        .font(systemName: .Splatfont2, size: 15)
                    VStack(alignment: .center, spacing: 0, content: {
                        Text(String(format: "%.2f", result.jobRate))
                            .font(systemName: .Splatfont2, size: 15)
                        Text(bundle: .CoopHistory_JobRatio)
                            .font(systemName: .Splatfont2, size: 10)
                            .foregroundColor(.white.opacity(0.6))
                    })
                    Text("+")
                        .font(systemName: .Splatfont2, size: 15)
                    VStack(alignment: .center, spacing: 0, content: {
                        Text(String(format: "%d", result.jobBonus))
                            .font(systemName: .Splatfont2, size: 15)
                        Text(bundle: .CoopHistory_Bonus)
                            .font(systemName: .Splatfont2, size: 10)
                            .foregroundColor(.white.opacity(0.6))
                    })
                })
                .padding(8)
                .frame(height: 48)
            })
        })
        .foregroundColor(.white)
    }
}

private extension String {
    init(format: String, _ arguments: CVarArg?) {
        if let arguments = arguments {
            self.init(format: format, arguments)
        } else {
            self.init("-")
        }
    }
}

private struct ResultScoreScale: View {
    @Environment(\.scale) var scale: CGFloat
    let result: RealmCoopResult

    var body: some View {
        ZStack(alignment: .center, content: {
            RoundedRectangle(cornerRadius: 10)
                .fill(Color.black.opacity(0.7))
            VStack(alignment: .leading, spacing: 0, content: {
                HStack(alignment: .center, spacing: nil, content: {
                    Text(String(format: "%@", result.grade?.localizedText))
                    Text(String(format: "%d", result.gradePoint))
                })
                .foregroundColor(SPColor.SplatNet3.SPSalmonGreen)
                .font(systemName: .Splatfont2, size: 12)
                .padding(.bottom, 5)
                ZStack(alignment: .leading, content: {
                    GeometryReader(content: { geometry in
                        Rectangle()
                            .fill(Color.white.opacity(0.2))
                        Rectangle()
                            .fill(SPColor.SplatNet3.SPSalmonOrange)
                            .frame(width: geometry.width * CGFloat(result.gradePoint ?? 0) / (result.grade == .Eggsecutive_VP ? 999 : 100))
                    })
                })
                .clipShape(RoundedRectangle(cornerRadius: 5))
                .frame(maxWidth: 170)
                .frame(height: 10)
                .padding(.bottom, 10)
                HStack(spacing: nil, content: {
                    HStack(spacing: 2, content: {
                        Image(bundle: .GoldenIkura)
                            .resizable()
                            .scaledToFit()
                            .frame(height: 16)
                        Text(String(format: "x%d", result.ikuraNum))
                            .font(systemName: .Splatfont2, size: 12)
                    })
                    HStack(spacing: 2, content: {
                        Image(bundle: .Ikura)
                            .resizable()
                            .scaledToFit()
                            .frame(height: 16)
                        Text(String(format: "x%d", result.ikuraNum))
                            .font(systemName: .Splatfont2, size: 12)
                    })
                })
                .frame(height: 17.5)
                .padding(.bottom, 5)
                HStack(spacing: 10, content: {
                    ForEach(result.scale.indices, id: \.self) { index in
                        let scale: Int? = result.scale[index]
                        let type: ScaleType = ScaleType.allCases[index]
                        HStack(spacing: 2, content: {
                            Image(bundle: type)
                                .resizable()
                                .scaledToFit()
                                .frame(height: 16)
                            Text(String(format: "x%d", scale))
                                .font(systemName: .Splatfont2, size: 12)
                        })
                    }
                })
                .frame(height: 17.5)
            })
            .padding(10)
            .frame(height: 96.5)
        })
        .foregroundColor(.white)
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
            .previewLayout(.fixed(width: 360, height: 200))
    }
}
