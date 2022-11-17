//
//  GrizzcoTeamCard.swift
//  Salmonia3+
//
//  Created by tkgstrator on 2022/10/21.
//

import SwiftUI
import SplatNet3

struct GrizzcoTeamView: View {
    @ObservedObject var data: Grizzco.ValueData

    var body: some View {
        Group(content: {
            GrizzcoTeamContent(icon: .Ikura, type: .Solo, data: data.ikuraNum)
            GrizzcoTeamContent(icon: .Ikura, type: .Team, data: data.teamIkuraNum)
            GrizzcoTeamContent(icon: .GoldenIkura, type: .Solo, data: data.goldenIkuraNum)
            GrizzcoTeamContent(icon: .GoldenIkura, type: .Team, data: data.teamGoldenIkuraNum)
            GrizzcoTeamContent(icon: .Salmon, type: .Solo, data: data.bossDefeatedNum)
            GrizzcoTeamContent(icon: .Salmon, type: .Team, data: data.teamBossDefeatedNum)
        })
    }
}

private struct GrizzcoTeamContent: View {
    let icon: ChartIconType
    let type: ChartType
    @ObservedObject var data: Grizzco.ValueEntry
    @Environment(\.colorScheme) var colorScheme: ColorScheme

    func content() -> some View {
        ZStack(alignment: .topLeading, content: {
            SPColor.SplatNet2.SPRed
            Image(chart: icon)
                .resizable()
                .scaledToFit()
                .frame(height: 20, alignment: .center)
                .padding([.leading, .top], 12)
            VStack(alignment: .center, spacing: 0, content: {
                Image(bundle: type)
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
                        Text(String(format: "x%d", data.max))
                    })
                    VStack(alignment: .center, spacing: 0, content: {
                        Text(bundle: .FesRecord_Average)
                            .font(systemName: .Splatfont2, size: 11)
                            .lineLimit(1)
                        Text(String(format: "x%.1f", data.avg))
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

    var body: some View {
        if #available(iOS 16.0, *), !data.isEmpty {
            ChartView(destination: {
                LineChartView(chart: data.chart)
            }, content: {
                content()
            })
        } else {
            content()
        }
    }
}
