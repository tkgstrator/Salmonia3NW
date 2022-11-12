//
//  GrizzcoStageCard.swift
//  Salmonia3+
//
//  Created by Shota Morimoto on 2022/11/05.
//  
//

import SwiftUI
import SplatNet3

struct GrizzcoStageCard: View {
//    let data: Grizzco.Record.Stage

    var body: some View {
        EmptyView()
//        HStack(alignment: .center, spacing: 0, content: {
//            ZStack(alignment: .bottom, content: {
//                Image(bundle: data.stageId)
//                    .resizable()
//                    .scaledToFill()
//                    .frame(width: 175, height: 80)
//                    .clipped()
//                Text(data.stageId.localizedText)
//                    .bold()
//                    .font(systemName: .Splatfont2, size: 14)
//                    .foregroundColor(.white)
//                    .padding(.horizontal)
//                    .background(Color.black)
//            })
//            ZStack(alignment: .leading, content: {
//                Rectangle()
//                    .foregroundColor(SPColor.SplatNet3.SPBackground)
//                VStack(alignment: .leading, spacing: nil, content: {
//                    if let maxGrade: GradeType = data.maxGrade,
//                       let maxGradePoint: Int = data.maxGradePoint
//                    {
//                        Text(String(format: "%@ %d", maxGrade.localizedText, maxGradePoint))
//                    } else {
//                        Text("- -")
//                    }
//                    HStack(content: {
//                        Spacer()
//                        Label(title: {
//                            Text(String(format: "x%d", data.teamGoldenIkuraMax))
//                                .frame(width: 30, alignment: .trailing)
//                        }, icon: {
//                            Image(bundle: .Golden)
//                                .resizable()
//                                .scaledToFit()
//                                .frame(width: 22, height: 18)
//                        })
////                        Spacer()
////                        Label(title: {
////                            Text(String(format: "x%d", data.goldenIkuraMax))
////                                .frame(width: 30, alignment: .trailing)
////                        }, icon: {
////                            Image(bundle: .Golden)
////                                .resizable()
////                                .scaledToFit()
////                                .frame(width: 22, height: 18)
////                        })
//                    })
//                })
//                .padding(.horizontal)
//            })
//            .frame(height: 80)
//            .font(systemName: .Splatfont2, size: 14)
//            .foregroundColor(.white)
//        })
//        .clipShape(RoundedRectangle(cornerRadius: 10))
    }
}

//struct GrizzcoStageCard_Previews: PreviewProvider {
//    typealias Entry = Grizzco.Record.Stage
//    static var data: [Grizzco.Record.Stage] = StageType.allCases.map({ stageId in
//        Entry(
//            stageId: stageId,
//            maxGrade: GradeType.allCases.randomElement(),
//            maxGradePoint: Int.random(in: 0...999),
//            minimumCount: Int.random(in: 48...96),
//            goldenIkuraMax: Int.random(in: 50...100),
//            ikuraMax: Int.random(in: 1000...2000),
//            teamGoldenIkuraMax: Int.random(in: 120...200),
//            teamIkuraMax: Int.random(in: 3000...6000))
//    })
//    static var previews: some View {
//        ScrollView(content: {
//            LazyVGrid(columns: Array(repeating: .init(.flexible(maximum: 197.5 * 2)), count: 1), content: {
//                ForEach(data, content: { entry in
//                    GrizzcoStageCard(data: entry)
//                })
//            })
//        })
//        .padding(.horizontal)
//    }
//}
