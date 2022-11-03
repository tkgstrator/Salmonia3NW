//
//  GrizzcoTeamCard.swift
//  Salmonia3+
//
//  Created by devonly on 2022/10/21.
//

import SwiftUI
import SplatNet3

struct GrizzcoTeamView: View {
    @ObservedObject var data: Grizzco.Chart.Values

    var body: some View {
        Group(content: {
            ForEach(data.ikuraNum) { value in
                if #available(iOS 16.0, *), !value.charts.data.isEmpty {
                    ChartView(destination: {
                        LineChartView(chartData: value.charts)
                    }, content: {
                        GrizzcoTeamContent(data: value)
                    })
                } else {
                    GrizzcoTeamContent(data: value)
                }
            }
            ForEach(data.goldenIkuraNum) { value in
                if #available(iOS 16.0, *), !value.charts.data.isEmpty {
                    ChartView(destination: {
                        LineChartView(chartData: value.charts)
                    }, content: {
                        GrizzcoTeamContent(data: value)
                    })
                } else {
                    GrizzcoTeamContent(data: value)
                }
            }
        })
    }
}

private struct GrizzcoTeamContent: View {
    @ObservedObject var data: Grizzco.Chart.Values.ValueEntry
    @Environment(\.colorScheme) var colorScheme: ColorScheme

    var body: some View {
        ZStack(alignment: .topLeading, content: {
            SPColor.SplatNet2.SPRed
            Image(chart: data.icon)
                .resizable()
                .scaledToFit()
                .frame(height: 20, alignment: .center)
                .padding([.leading, .top], 12)
            VStack(alignment: .center, spacing: 0, content: {
                Image(bundle: data.type)
                    .resizable()
                    .scaledToFit()
                    .frame(height: 20)
                    .padding(.top, 12)
                Spacer()
                LazyVGrid(columns: Array(repeating: .init(.flexible(), spacing: 0), count: 2), content: {
                    VStack(alignment: .center, spacing: 0, content: {
                        Text(bundle: .CoopHistory_HighestScore)
                            .font(systemName: .Splatfont2, size: 11)
                            .lineLimit(1)
                        Text(String(format: "x%d", data.maxValue))
                    })
                    VStack(alignment: .center, spacing: 0, content: {
                        Text(bundle: .FesRecord_Average)
                            .font(systemName: .Splatfont2, size: 11)
                            .lineLimit(1)
                        Text(String(format: "x%.1f", data.avgValue))
                    })
                })
                .font(systemName: .Splatfont2, size: 14)
                .foregroundColor(Color.white)
            })
            .padding(.bottom, 4)
            .padding(.horizontal)
        })
        .aspectRatio(300/160, contentMode: .fit)
        .mask(Image(bundle: .Card).resizable().scaledToFill())
        .clipShape(RoundedRectangle(cornerRadius: 10))
    }
}

//struct GrizzcoTeamCard_Previews: PreviewProvider {
//    static var previews: some View {
//        ScrollView(content: {
//            LazyVGrid(columns: Array(repeating: .init(.flexible()), count: 2), content: {
//                GrizzcoTeamCard(chartType: .Solo, buttonType: .GoldenIkura)
//                GrizzcoTeamCard(chartType: .Team, buttonType: .GoldenIkura)
//                GrizzcoTeamCard(chartType: .Solo, buttonType: .Ikura)
//                GrizzcoTeamCard(chartType: .Team, buttonType: .Ikura)
//                GrizzcoTeamCard(chartType: .Solo, buttonType: .Salmon)
//                GrizzcoTeamCard(chartType: .Team, buttonType: .Salmon)
//            })
//        })
//        .padding(.horizontal)
//    }
//}
