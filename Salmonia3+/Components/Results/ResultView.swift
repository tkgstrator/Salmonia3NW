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

    var body: some View {
        ResultSplatNet3(result: result)
    }
}

private struct ResultSplatNet3: View {
    let result: RealmCoopResult

    var body: some View {
        HStack(alignment: .center, spacing: 0, content: {
            VStack(alignment: .leading, spacing: 0, content: {
                Text(bundle: result.isClear ? .CoopHistory_Clear : .CoopHistory_Failure)
                    .foregroundColor(result.isClear ? SPColor.SplatNet2.SPYellow : Color.white)
                    .font(systemName: .Splatfont, size: 14)
                if let gradeId = result.grade, let gradePoint = result.gradePoint {
                    HStack(alignment: .center, spacing: 2, content: {
                        Text(String(format: "%@ %d", gradeId.localizedText, gradePoint))
                        Text(String(format: "%@", result.gradeArrow.rawValue))
                            .foregroundColor(result.gradeArrow.color)
                    })
                    .foregroundColor(Color.white)
                    .font(systemName: .Splatfont, size: 14)
                }
            })
            Spacer()
            if let isBossDefeated = result.isBossDefeated {
                Image(bundle: .SakelienGiant)
                    .renderingMode(.template)
                    .resizable()
                    .scaledToFit()
                    .foregroundColor(isBossDefeated ? SPColor.SplatNet3.SPYellow : SPColor.SplatNet2.SPWhite)
                    .frame(height: 40)
                    .padding(.trailing, 8)
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
//                            .frame(maxWidth: .infinity, alignment: .trailing)
                    }, icon: {
                        Image(bundle: .GoldenIkura)
                            .resizable()
                            .scaleEffect()
                            .frame(width: 18, height: 18, alignment: .center)
                            .padding(.trailing, 2.5)
                    })
                    Label(title: {
                        Text(String(format: "x%d", result.ikuraNum))
                            .lineLimit(1)
                            .foregroundColor(SPColor.SplatNet2.SPWhite)
                            .frame(minWidth: 40, alignment: .trailing)
//                            .frame(maxWidth: .infinity, alignment: .trailing)
                    }, icon: {
                        Image(bundle: .Ikura)
                            .resizable()
                            .scaleEffect()
                            .frame(width: 20.5, height: 15, alignment: .center)
                            .padding(.trailing, 2.5)
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
        .background(result.isClear ? SPColor.SplatNet3.SPSalmonOrange : SPColor.SplatNet3.SPSalmonOrangeDarker)
        .padding(.bottom, 2)
    }
}

private struct ResultSpletNet2: View {
    let result: RealmCoopResult
    let fontSize: CGFloat = 14

    var body: some View {
        HStack(alignment: .center, spacing: 0, content: {
            VStack(alignment: .leading, spacing: 0, content: {
                Text(bundle: result.isClear ? .CoopHistory_Clear : .CoopHistory_Failure)
                    .foregroundColor(SPColor.SplatNet2.SPGreen)
                    .font(systemName: .Splatfont, size: 14)
                if let gradeId = result.grade, let gradePoint = result.gradePoint {
                    HStack(alignment: .center, spacing: 2, content: {
                        Text(String(format: "%@ %d", gradeId.localizedText, gradePoint))
                        Text(String(format: "%@", result.gradeArrow.rawValue))
                            .foregroundColor(result.gradeArrow.color)
                    })
                    .font(systemName: .Splatfont, size: 16)
                }
            })
            Spacer()
            VStack(alignment: .leading, spacing: 4, content: {
                HStack(spacing: 4, content: {
                    Image(bundle: .GoldenIkura)
                        .resizable()
                        .scaleEffect()
                        .frame(width: 18, height: 18, alignment: .center)
                        .padding(.trailing, 2.5)
                    Text(String(format: "x%d", result.goldenIkuraNum))
                        .lineLimit(1)
                        .frame(width: 48, alignment: .leading)
                        .foregroundColor(SPColor.SplatNet2.SPWhite)
                })
                HStack(spacing: 4, content: {
                    Image(bundle: .Ikura)
                        .resizable()
                        .scaleEffect()
                        .frame(width: 20.5, height: 15, alignment: .center)
                    Text(String(format: "x%d", result.ikuraNum))
                        .lineLimit(1)
                        .frame(width: 48, alignment: .leading)
                        .foregroundColor(SPColor.SplatNet2.SPWhite)
                })
            })
            .font(systemName: .Splatfont2, size: 16)
        })
        .frame(height: 48)
        .foregroundColor(Color.white)
        .padding(.leading, 20)
        .padding(.trailing, 10)
        .background(RoundedRectangle(cornerRadius: 24).fill(Color.black.opacity(0.75)))
        .padding(.bottom, 8)
        .padding(.horizontal, 8)
    }
}

enum GradeArrow: String, CaseIterable {
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

fileprivate extension RealmCoopResult {
    var gradeArrow: GradeArrow {
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

struct ResultView_Previews: PreviewProvider {
    static let result: RealmCoopResult = RealmCoopResult(dummy: true)
    static var previews: some View {
        ResultView(result: result)
            .previewLayout(.fixed(width: 450, height: 60))
        ResultView(result: result)
            .previewLayout(.fixed(width: 400, height: 60))
        ResultView(result: result)
            .previewLayout(.fixed(width: 375, height: 60))
    }
}
