//
//  WaveChart.swift
//  Salmonia3+
//
//  Created by devonly on 2022/10/21.
//

import SwiftUI
import SplatNet3

struct WaveChartView: View {

    func isInvalidWave(eventType: EventType, waterLevel: WaterType) -> Bool {
        switch (eventType, waterLevel) {
        case (.Rush, .Low_Tide),
            (.Goldie_Seeking, .Low_Tide),
            (.Griller, .Low_Tide),
            (.Cohock_Charge, .Middle_Tide),
            (.Cohock_Charge, .High_Tide),
            (.Giant, .Middle_Tide),
            (.Giant, .High_Tide),
            (.Mudmouth, .Low_Tide):
            return true
        default:
            return false
        }
    }

    var body: some View {
        LazyVGrid(columns: Array(repeating: .init(.flexible()), count: 3), content: {
            ForEach(EventType.allCases, id: \.rawValue) { eventType in
                ForEach(WaterType.allCases, id: \.rawValue) { waterType in
                    WaveChart(eventType: eventType, waterLevel: waterType)
                        .isInvalidWave(eventType: eventType, waterLevel: waterType)
                }
            }
        })
    }
}

extension WaveChart {
    func isInvalidWave(eventType: EventType, waterLevel: WaterType) -> some View {
        switch (eventType, waterLevel) {
        case (.Rush, .Low_Tide),
            (.Goldie_Seeking, .Low_Tide),
            (.Griller, .Low_Tide),
            (.Cohock_Charge, .Middle_Tide),
            (.Cohock_Charge, .High_Tide),
            (.Giant, .Middle_Tide),
            (.Giant, .High_Tide),
            (.Mudmouth, .Low_Tide):
            return AnyView(self.hidden())
        default:
            return AnyView(self)
        }
    }
}

private struct WaveChart: View {
    let eventType: EventType
    let waterLevel: WaterType
    let offset: CGFloat

    init(eventType: EventType, waterLevel: WaterType) {
        self.eventType = eventType
        self.waterLevel = waterLevel
        self.offset = {
            switch waterLevel {
            case .Low_Tide:
                return 110
            case .Middle_Tide:
                return 95
            case .High_Tide:
                return 80
            }
        }()
    }

    var body: some View {
        ZStack(alignment: .top, content: {
            Image(bundle: .MOCK)
                .renderingMode(.template)
                .resizable()
                .scaledToFit()
                .foregroundColor(SPColor.SplatNet2.SPBackground)
                .overlay(Image(bundle: .Wave).resizable().scaledToFill().offset(x: 0, y: offset).opacity(0.5))
                .clipped()
            VStack(alignment: .leading, spacing: 0, content: {
                HStack(alignment: .top, spacing: 0, content: {
                    VStack(alignment: .leading, spacing: 0, content: {
                        Text(eventType.localizedText)
                            .lineLimit(1)
                    })
                    Spacer()
                    Text(String(format: "x%d", 99))
                })
                .font(systemName: .Splatfont2, size: 11)
                Spacer()
                HStack(content: {
                    HStack(alignment: .center, spacing: 0, content: {
                        Image(bundle: .GoldenIkura)
                            .resizable()
                            .scaledToFit()
                            .frame(width: 14, height: 14, alignment: .center)
                            .padding(.trailing, 4)
                        Text(String(format: "x%d", 999))
                    })
                    Spacer()
                    HStack(alignment: .center, spacing: 0, content: {
                        Image(bundle: .GoldenIkura)
                            .resizable()
                            .scaledToFit()
                            .frame(width: 14, height: 14, alignment: .center)
                            .padding(.trailing, 4)
                        Text(String(format: "x%.2f", 999.99))
                    })
                })
                .padding(.bottom, 4)
                ZStack(alignment: .center, content: {
                    let randomValue: Double = Double.random(in: 0...1)
                    GeometryReader(content: { geometry in
                        Rectangle()
                            .fill(Color.white.opacity(0.3))
                        Rectangle()
                            .fill(SPColor.SplatNet3.SPSalmonOrange)
                            .frame(width: geometry.width * randomValue)
                    })
                    Text(String(format: "%.2f%%", randomValue * 100))
                        .shadow(color: Color.black, radius: 0, x: 1, y: 1)
                })
                .frame(height: 10)
                .clipShape(RoundedRectangle(cornerRadius: 6))
            })
            .foregroundColor(Color.white)
            .font(systemName: .Splatfont2, size: 10)
            .padding(.top, 2)
            .padding(.all, 4)
        })
        .cornerRadius(10)
    }
}

struct WaveChart_Previews: PreviewProvider {
    static var previews: some View {
        ScrollView(content: {
            WaveChartView()
        })
    }
}
