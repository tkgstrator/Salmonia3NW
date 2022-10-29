//
//  GrizzcoTeamCard.swift
//  Salmonia3+
//
//  Created by devonly on 2022/10/21.
//

import SwiftUI
import SplatNet3

struct GrizzcoTeamCardView: View {
    @ObservedObject var stats: StatsService

    var body: some View {
        GrizzcoTeamCard(team: stats.ikuraNum, chartType: .Solo, buttonType: .Ikura)
        GrizzcoTeamCard(team: stats.teamIkuraNum, chartType: .Team, buttonType: .Ikura)
        GrizzcoTeamCard(team: stats.goldenIkuraNum, chartType: .Solo, buttonType: .GoldenIkura)
        GrizzcoTeamCard(team: stats.teamGoldenIkuraNum, chartType: .Team, buttonType: .GoldenIkura)
        GrizzcoTeamCard(team: stats.defeatedNum, chartType: .Solo, buttonType: .Salmon)
        GrizzcoTeamCard(team: stats.teamDefeatedNum, chartType: .Team, buttonType: .Salmon)
    }
}

private struct GrizzcoTeamCard: View {
    @Environment(\.colorScheme) var colorScheme: ColorScheme
    @ObservedObject var team: Grizzco.TeamData
    let chartType: ChartType
    let buttonType: ButtonType

    init(team: Grizzco.TeamData, chartType: ChartType, buttonType: ButtonType) {
        self.team = team
        self.chartType = chartType
        self.buttonType = buttonType
    }

    var body: some View {
        ZStack(alignment: .topLeading, content: {
            SPColor.SplatNet2.SPRed
            Image(bundle: buttonType)
                .resizable()
                .scaledToFit()
                .frame(height: 20, alignment: .center)
                .padding([.leading, .top], 12)
            VStack(alignment: .center, spacing: 0, content: {
                Image(bundle: chartType)
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
                        Text(String(format: "x%d", team.maxValue))
                    })
                    VStack(alignment: .center, spacing: 0, content: {
                        Text(bundle: .FesRecord_Average)
                            .font(systemName: .Splatfont2, size: 11)
                            .lineLimit(1)
                        Text(String(format: "x%.1f", team.avgValue))
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
