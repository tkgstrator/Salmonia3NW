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
        NavigationLinker(destination: {
            ResultView(result: result)
//                .environment(\.coopSchedule, result.schedule)
        }, label: {
            _ResultElement(result: result)
        })
        .listRowInsets(EdgeInsets())
        .listRowSeparator(.hidden)
    }
}

private struct _ResultElement: View {
    let result: RealmCoopResult


    fileprivate enum GradePointDiff: String, CaseIterable {
        case UP     = "↑"
        case STAY   = "→"
        case DOWN   = "↓"

        var color: Color {
            switch self {
            case .UP:
                return Color.white
            case .STAY:
                return Color.gray
            case .DOWN:
                return Color.gray
            }
        }
    }

    private func BossResult() -> some View {
        if let bossId: EnemyId = result.bossId, let isDefeated: Bool = result.isBossDefeated {
            return Image(bossId)
                .renderingMode(.template)
                .resizable()
                .scaledToFit()
                .foregroundColor(isDefeated ? SPColor.SplatNet3.SPYellow : SPColor.SplatNet2.SPWhite)
                .frame(height: 40)
                .padding(.trailing, 8)
                .asAnyView()
        } else {
            return EmptyView()
                .asAnyView()
        }
    }

    private func GradePoint() -> some View {
        HStack(alignment: .center, spacing: 2, content: {
            HStack(spacing: 8, content: {
                Text(result.grade)
                Text(result.gradePoint)
                Text(result.gradePointDiff.rawValue)
                    .foregroundColor(result.gradePointDiff.color)
            })
        })
        .foregroundColor(Color.white)
        .font(systemName: .Splatfont, size: 14)
    }

    private func Result() -> some View {
        VStack(alignment: .center, spacing: 0, content: {
            HStack(content: {
                GoldenIkura(frame: CGSize(width: 20.5, height: 18))
                Text(String(format: "x%d", result.goldenIkuraNum))
                    .lineLimit(1)
                    .foregroundColor(SPColor.SplatNet2.SPWhite)
                    .frame(width: 36, alignment: .trailing)
            })
            HStack(content: {
                Ikura(frame: CGSize(width: 20.5, height: 15))
                Text(String(format: "x%d", result.ikuraNum))
                    .lineLimit(1)
                    .foregroundColor(SPColor.SplatNet2.SPWhite)
                    .frame(width: 36, alignment: .trailing)
            })
        })
        .padding(6)
        .background(alignment: .center, content: {
            Color.black.opacity(0.7).cornerRadius(10)
        })
        .font(systemName: .Splatfont2, size: 12)
    }

    var body: some View {
        HStack(alignment: .center, spacing: 0, content: {
            VStack(alignment: .leading, spacing: 0, content: {
                Text(bundle: result.isClear ? .CoopHistory_Clear : .CoopHistory_Failure)
                    .foregroundColor(result.isClear ? SPColor.SplatNet2.SPYellow : Color.white)
                    .font(systemName: .Splatfont, size: 14)
                GradePoint()
            })
            Spacer()
            BossResult()
            Result()
        })
        .padding(.horizontal, 8)
        .padding(.vertical, 4)
        .background(result.isClear ? SPColor.SplatNet3.SPSalmonOrange : SPColor.SplatNet3.SPSalmonOrangeDarker)
        .padding(.bottom, 2)
    }
}


fileprivate extension RealmCoopResult {
    var gradePointDiff: _ResultElement.GradePointDiff {
        switch self.waves.count {
        case 3:
            return self.isClear ? .UP : .STAY
        case 4:
            return .UP
        default:
            return .DOWN
        }
    }
}



//struct ResultElement_Previews: PreviewProvider {
//    static var previews: some View {
//        ResultElement()
//    }
//}
