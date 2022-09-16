//
//  ResultView.swift
//  Salmonia3+
//
//  Created by devonly on 2022/09/16.
//

import SwiftUI
import SplatNet3

struct ResultView: View {
    let result: RealmCoopResult
    let fontSize: CGFloat = 14

    var body: some View {
        HStack(content: {
            switch result.isClear {
            case true:
                let foregroundColor: Color = Color(hex: "")
                Text("Clear")
                    .frame(width: 60, height: nil, alignment: .center)
                    .font(systemName: .Splatfont, size: fontSize)
                    .foregroundColor(.green)
            case false:
                Text("Defeat")
                    .frame(width: 60, height: nil, alignment: .center)
                    .font(systemName: .Splatfont, size: fontSize)
                    .foregroundColor(.orange)
            }
            VStack(alignment: .leading, spacing: nil, content: {
                HStack(spacing: nil, content: {
                    if let gradeId = result.grade, let gradeType = GradeType(id: gradeId) {
                        Text(gradeType.localizedText)
                            .lineLimit(1)
                            .font(systemName: .Splatfont, size: fontSize)
                    }
                    if let gradePoint = result.gradePoint {
                        Text("\(gradePoint)")
                            .lineLimit(1)
                            .font(systemName: .Splatfont, size: fontSize)
                    }
                    if let gradePoint = result.gradePoint {
                        if result.isClear {
                            switch gradePoint == 999 {
                            case true:
                                Text("→")
                                    .font(systemName: .Splatfont, size: 18)
                            case false:
                                Text("↑")
                                    .font(systemName: .Splatfont, size: 18)
                                    .foregroundColor(.yellow)
                            }
                        }

                        if !result.isClear {
                            switch result.waves.count == 3 {
                            case true:
                                Text("→")
                                    .font(systemName: .Splatfont, size: 18)
                            case false:
                                Text("↓")
                                    .font(systemName: .Splatfont, size: 18)
                                    .foregroundColor(.gray)
                            }
                        }
                    }
                })
            })
            Spacer()
            VStack(alignment: .leading, content: {
                HStack(content: {
                    Image(bundle: IkuraType.Golden)
                        .resizable()
                        .scaledToFit()
                        .frame(width: nil, height: 20, alignment: .leading)
                    Spacer()
                    Text("x\(result.goldenIkuraNum)")
                        .frame(height: 20)
                })
                HStack(content: {
                    Image(bundle: IkuraType.Power)
                        .resizable()
                        .scaledToFit()
                        .frame(width: nil, height: 20, alignment: .leading)
                    Spacer()
                    Text("x\(result.ikuraNum)")
                        .frame(height: 20)
                })
            })
            .frame(width: 80, height: nil, alignment: .trailing)
            .font(systemName: .Splatfont2, size: 16)
        })
    }
}

struct ResultView_Previews: PreviewProvider {
    static let result: RealmCoopResult = RealmCoopResult(dummy: true)
    static var previews: some View {
        ResultView(result: result)
            .previewLayout(.fixed(width: 400, height: 100))
            .preferredColorScheme(.dark)
    }
}
