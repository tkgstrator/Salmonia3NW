//
//  ResultElement.swift
//  Salmonia3+
//  
//  Created by devonly on 2022/11/27
//  Copyright © 2022 Magi Corporation. All rights reserved.
//

import SwiftUI
import SplatNet3

struct ResultElement: View {
    let result: RealmCoopResult

    var body: some View {
        _ResultElement(result: result)
    }
}

private struct _ResultElement: View {
    let result: RealmCoopResult

    var body: some View {
        HStack(alignment: .center, spacing: 0, content: {
            VStack(alignment: .leading, spacing: 0, content: {
                Text(bundle: result.isClear ? .CoopHistory_Clear : .CoopHistory_Failure)
                    .foregroundColor(result.isClear ? SPColor.SplatNet2.SPYellow : Color.white)
                    .font(systemName: .Splatfont, size: 14)
                if let gradeId = result.grade, let gradePoint = result.gradePoint {
                    HStack(alignment: .center, spacing: 2, content: {
//                        Text(String(format: "%@ %d", gradeId.localizedText, gradePoint))
//                        Text(String(format: "%@", result.gradeArrow.rawValue))
//                            .foregroundColor(result.gradeArrow.color)
                    })
                    .foregroundColor(Color.white)
                    .font(systemName: .Splatfont, size: 14)
                }
            })
            Spacer()
            if let isBossDefeated = result.isBossDefeated {
//                Image(bundle: .SakelienGiant)
//                    .renderingMode(.template)
//                    .resizable()
//                    .scaledToFit()
//                    .foregroundColor(isBossDefeated ? SPColor.SplatNet3.SPYellow : SPColor.SplatNet2.SPWhite)
//                    .frame(height: 40)
//                    .padding(.trailing, 8)
            }
            ZStack(alignment: .center, content: {
                RoundedRectangle(cornerRadius: 10)
                    .fill(Color.black.opacity(0.7))
                VStack(alignment: .center, spacing: 0, content: {
                    Label(title: {
                        Text(String(format: "x%d", result.goldenIkuraNum))
                            .lineLimit(1)
                            .foregroundColor(SPColor.SplatNet2.SPWhite)
                            .frame(minWidth: 40, alignment: .trailing)
                    }, icon: {
//                        Image(bundle: .GoldenIkura)
//                            .resizable()
//                            .scaleEffect()
//                            .frame(width: 18, height: 18, alignment: .center)
//                            .padding(.trailing, 2.5)
                    })
                    Label(title: {
                        Text(String(format: "x%d", result.ikuraNum))
                            .lineLimit(1)
                            .foregroundColor(SPColor.SplatNet2.SPWhite)
                            .frame(minWidth: 40, alignment: .trailing)
                    }, icon: {
//                        Image(bundle: .Ikura)
//                            .resizable()
//                            .scaleEffect()
//                            .frame(width: 20.5, height: 15, alignment: .center)
//                            .padding(.trailing, 2.5)
                    })
                })
                .padding(.horizontal, 4)
                .font(systemName: .Splatfont2, size: 12)
            })
            .frame(maxWidth: 78)
            .frame(maxHeight: 48)
            .padding(.vertical, 2)
        })
        .padding(.leading)
        .padding(.trailing, 8)
        .padding(.vertical, 4)
//        .background(
//            result.isClear
//            ? appearances.gamingScheme
//            ? AnyView(Rainbow())
//            : AnyView(SPColor.SplatNet3.SPSalmonOrange)
//            : AnyView(SPColor.SplatNet3.SPSalmonOrangeDarker)
//        )
        .padding(.bottom, 2)
    }
}

//struct ResultElement_Previews: PreviewProvider {
//    static var previews: some View {
//        ResultElement()
//    }
//}
