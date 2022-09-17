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
        GeometryReader(content: { geometry in
            let scale: CGFloat = min(1.0, geometry.height / 80)
            VStack(alignment: .leading, spacing: 0, content: {
                HStack(alignment: .center, spacing: 0, content: {
                    let title: String = result.isClear ? "Clear!" : "Defeat"
                    Text(title)
                        .font(systemName: .Splatfont, size: 20 * scale)
                        .foregroundColor(result.isClear ? .green : .orange)
                        .frame(height: 20 * scale)
                    Spacer()
                    ResultEgg(
                        ikuraNum: result.ikuraNum,
                        goldenIkuraNum: result.goldenIkuraNum,
                        goldenIkuraAssistNum: result.goldenIkuraAssistNum)
                })
                .frame(height: 30 * scale)
                HStack(alignment: .center, spacing: nil, content: {
                    if let grade = result.grade, let gradePoint = result.gradePoint {
                        Group(content: {
                            Text(grade.localizedText)
                            Text("\(gradePoint)")
                        })
                        Group(content: {
                            if result.isClear && gradePoint != 999 {
                                Text("↑")
                                    .foregroundColor(.orange)
                            }
                            if result.isClear && gradePoint == 999 {
                                Text("→")
                            }
                            if !result.isClear && result.waves.count == 3 {
                                Text("→")
                            }
                            if !result.isClear && result.waves.count != 3 {
                                Text("↓")
                                    .foregroundColor(.gray)
                            }
                        })
                        Spacer()
                        if result.waves.count == 4 {
                            Image("SakelienType/99", bundle: .main)
                                .renderingMode(.template)
                                .resizable()
                                .scaledToFit()
                                .foregroundColor(.orange)
                                .padding(4 * scale)
                        }
                    }
                })
                .font(systemName: .Splatfont, size: 18 * scale)
                .frame(height: 50 * scale)
            })
        })
        .frame(minHeight: 80)
//        .aspectRatio(400/80, contentMode: .fit)
    }
}

struct ResultView_Previews: PreviewProvider {
    static let result: RealmCoopResult = RealmCoopResult(dummy: true)
    static var previews: some View {
        ResultView(result: result)
            .previewLayout(.fixed(width: 400, height: 80))
            .preferredColorScheme(.dark)
        ResultView(result: result)
            .previewLayout(.fixed(width: 200, height: 40))
            .preferredColorScheme(.dark)
    }
}
