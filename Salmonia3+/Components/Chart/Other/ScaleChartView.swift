//
//  ScaleChartView.swift
//  Salmonia3+
//
//  Created by devonly on 2022/10/12.
//

import SwiftUI
import SwiftUICharts
import SplatNet3

class ScaleData: ObservableObject {
    @Published var gold: Int
    @Published var silver: Int
    @Published var bronze: Int

    init(gold: Int, silver: Int, bronze: Int) {
        self.gold = gold
        self.silver = silver
        self.bronze = bronze
    }
}

struct ScaleChartView: View {
    @Environment(\.colorScheme) var colorScheme
    @ObservedObject var data: ScaleData

    var body: some View {
        ZStack(alignment: .center, content: {
            VStack(alignment: .center, spacing: 0, content: {
                Rectangle()
                    .fill(Color.black)
                    .aspectRatio(120/22, contentMode: .fit)
                    .overlay(
                        Text(bundle: .CoopHistory_Scale)
                            .foregroundColor(SPColor.SplatNet2.SPOrange)
                            .font(systemName: .Splatfont2, size: 14)
                    )
                ZStack(alignment: .center, content: {
                    Rectangle()
                        .fill(SPColor.SplatNet2.SPBackground)
                    LazyVGrid(columns: Array(repeating: .init(.flexible(maximum: 60)), count: 3), content: {
                        VStack(alignment: .center, spacing: 0, content: {
                            Image(bundle: .Bronze)
                                .resizable()
                                .scaledToFit()
                                .frame(width: 30, height: 30, alignment: .center)
                            Text(String(format: "x%d", data.bronze))
                                .font(systemName: .Splatfont2, size: 14)
                        })
                        VStack(alignment: .center, spacing: 0, content: {
                            Image(bundle: .Silver)
                                .resizable()
                                .scaledToFit()
                                .frame(width: 30, height: 30, alignment: .center)
                            Text(String(format: "x%d", data.silver))
                                .font(systemName: .Splatfont2, size: 14)
                        })
                        VStack(alignment: .center, spacing: 0, content: {
                            Image(bundle: .Gold)
                                .resizable()
                                .scaledToFit()
                                .frame(width: 30, height: 30, alignment: .center)
                            Text(String(format: "x%d", data.gold))
                                .font(systemName: .Splatfont2, size: 14)
                        })
                    })
                    .foregroundColor(.white)
                    .padding([.bottom, .top])
                })
            })
        })
        .clipShape(RoundedRectangle(cornerRadius: 20))
        .shadow(color: .primary, radius: 2, x: 0, y: 0)
        .aspectRatio(120/50, contentMode: .fit)
    }
}

struct ScaleChartView_Previews: PreviewProvider {
    static let point: Grizzco.PointData = Grizzco.PointData(
        playCount: 999,
        ikuraNum: 999999,
        goldenIkuraNum: 99999,
        bossKillCount: 999,
        regularPoint: 999999,
        regularPointTotal: nil,
        rescueCount: 9999
    )

    static let maximum: Grizzco.HighData = Grizzco.HighData(
        maxGrade: .Eggsecutive_VP,
        maxGradePoint: 600,
        averageWaveCleared: 2.75
    )

    static let scale: Grizzco.ScaleData = Grizzco.ScaleData(
        gold: 999,
        silver: 999,
        bronze: 999
    )

    static let average: Grizzco.AverageData = Grizzco.AverageData(
        weaponList: Array(WeaponType.allCases.shuffled().prefix(4)),
        rareWeapon: WeaponType.Stringer_Bear_Coop,
        ikuraNum: 9999.9,
        goldenIkuraNum: 999.9,
        helpCount: 99.9,
        deadCount: 99.9
    )

    static var previews: some View {
        EmptyView()
        .previewLayout(.fixed(width: 600, height: 800))
        .preferredColorScheme(.dark)
    }
}
