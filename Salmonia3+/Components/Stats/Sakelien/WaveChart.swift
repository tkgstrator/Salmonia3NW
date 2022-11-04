//
//  WaveChart.swift
//  Salmonia3+
//
//  Created by tkgstrator on 2022/10/21.
//

import SwiftUI
import SplatNet3

//struct WaveChartView: View {
//    let waves: [Grizzco.WaveData]
//
//    func isInvalidWave(eventType: EventType, waterLevel: WaterType) -> Bool {
//        switch (eventType, waterLevel) {
//        case (.Rush, .Low_Tide),
//            (.Goldie_Seeking, .Low_Tide),
//            (.Griller, .Low_Tide),
//            (.Cohock_Charge, .Middle_Tide),
//            (.Cohock_Charge, .High_Tide),
//            (.Giant, .Middle_Tide),
//            (.Giant, .High_Tide),
//            (.Mudmouth, .Low_Tide):
//            return true
//        default:
//            return false
//        }
//    }
//
//    var body: some View {
//        ScrollView(showsIndicators: false, content: {
//            LazyVGrid(columns: Array(repeating: .init(.flexible(maximum: 150)), count: 3), content: {
//                ForEach(waves, id: \.self) { wave in
//                    WaveChart(wave: wave)
//                        .isInvalidWave(wave: wave)
//                }
//            })
//        })
//        .padding(.horizontal, 8)
//        .navigationTitle(Text(bundle: .CoopHistory_HighestScore))
//    }
//}
//
//extension WaveChart {
//    func isInvalidWave(wave: Grizzco.WaveData) -> some View {
//        isInvalidWave(eventType: wave.eventType, waterLevel: wave.waterLevel)
//    }
//
//    func isInvalidWave(eventType: EventType, waterLevel: WaterType) -> some View {
//        switch (eventType, waterLevel) {
//        case (.Rush, .Low_Tide),
//            (.Goldie_Seeking, .Low_Tide),
//            (.Griller, .Low_Tide),
//            (.Cohock_Charge, .Middle_Tide),
//            (.Cohock_Charge, .High_Tide),
//            (.Giant, .Middle_Tide),
//            (.Giant, .High_Tide),
//            (.Mudmouth, .Low_Tide):
//            return AnyView(self.hidden())
//        default:
//            return AnyView(self)
//        }
//    }
//}
//
//private struct WaveChart: View {
//    let eventType: EventType
//    let waterLevel: WaterType
//    var count: Int
//    var goldenIkuraMax: Int?
//    var goldenIkuraAvg: Double?
//    var scale: Double?
//    let offset: CGFloat
//
//    init(wave: Grizzco.WaveData) {
//        self.init(eventType: wave.eventType, waterLevel: wave.waterLevel)
//        self.goldenIkuraAvg = wave.goldenIkuraAvg
//        self.goldenIkuraMax = wave.goldenIkuraMax
//        self.scale = wave.clearRatio
//        self.count = wave.count
//    }
//
//    init(eventType: EventType, waterLevel: WaterType) {
//        self.eventType = eventType
//        self.waterLevel = waterLevel
//        self.goldenIkuraMax = 999
//        self.goldenIkuraAvg = 999.99
//        self.count = 99
//        self.scale = 1.0
//        self.offset = {
//            switch waterLevel {
//            case .Low_Tide:
//                return 120
//            case .Middle_Tide:
//                return 105
//            case .High_Tide:
//                return 90
//            }
//        }()
//    }
//
//    var body: some View {
//        ZStack(alignment: .top, content: {
//            SPColor.SplatNet3.SPBlue.opacity(0.85)
//                .overlay(Image(bundle: .Wave).resizable().scaledToFill().offset(x: 0, y: offset).opacity(0.3))
//            VStack(alignment: .leading, spacing: 0, content: {
//                HStack(alignment: .top, spacing: 0, content: {
//                    VStack(alignment: .leading, spacing: 0, content: {
//                        Text(eventType.localizedText)
//                            .lineLimit(1)
//                            .shadow(color: Color.black, radius: 0, x: 1, y: 1)
//                    })
//                    Spacer()
////                    Text(String(format: "x%d", count))
////                        .shadow(color: Color.black, radius: 0, x: 1, y: 1)
//                })
//                .font(systemName: .Splatfont2, size: 12)
//                Spacer()
//                HStack(content: {
//                    HStack(alignment: .center, spacing: 0, content: {
//                        Image(bundle: .GoldenIkura)
//                            .resizable()
//                            .scaledToFit()
//                            .frame(width: 12, height: 12, alignment: .center)
//                            .padding(.trailing, 4)
//                        Text(String(format: "x%d", goldenIkuraMax))
//                            .shadow(color: Color.black, radius: 0, x: 1, y: 1)
//                    })
//                    Spacer()
//                    HStack(alignment: .center, spacing: 0, content: {
//                        Image(bundle: .GoldenIkura)
//                            .resizable()
//                            .scaledToFit()
//                            .frame(width: 12, height: 12, alignment: .center)
//                            .padding(.trailing, 4)
//                        Text(String(format: "x%.1f", goldenIkuraAvg))
//                            .shadow(color: Color.black, radius: 0, x: 1, y: 1)
//                    })
//                })
//                .padding(.bottom, 4)
//                ZStack(alignment: .center, content: {
//                    GeometryReader(content: { geometry in
//                        Rectangle()
//                            .fill(Color.black.opacity(0.6))
//                        if let scale = scale {
//                            Rectangle()
//                                .fill(SPColor.SplatNet3.SPSalmonOrange)
//                                .frame(width: geometry.width * scale / 100)
//                        }
//                    })
//                    Text(String(format: "%.1f%%", scale))
//                        .font(systemName: .Splatfont2, size: 10)
//                        .shadow(color: Color.black, radius: 0, x: 1, y: 1)
//                })
//                .frame(height: 10)
//                .clipShape(RoundedRectangle(cornerRadius: 5))
//            })
//            .foregroundColor(Color.white)
//            .font(systemName: .Splatfont2, size: 13)
//            .padding(.top, 2)
//            .padding(.all, 8)
//        })
//        .cornerRadius(10)
//        .aspectRatio(2, contentMode: .fit)
//    }
//}
//
//struct WaveChart_Previews: PreviewProvider {
//    static let waves: [Grizzco.WaveData] = {
//        return EventType.allCases.flatMap({ eventType in
//            WaterType.allCases.map({ waterLevel in
//                Grizzco.WaveData(
//                    eventType: eventType,
//                    waterLevel: waterLevel,
//                    count: Int.random(in: 0...99),
//                    goldenIkuraMax: Int.random(in: 0...99),
//                    goldenIkuraAvg: Double.random(in: 0...99),
//                    clearRatio: nil
//                )
//            })
//        })
//    }()
//    static var previews: some View {
//        ScrollView(content: {
//            WaveChartView(waves: waves)
//        })
//    }
//}
