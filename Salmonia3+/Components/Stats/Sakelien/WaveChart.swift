//
//  WaveChart.swift
//  Salmonia3+
//
//  Created by tkgstrator on 2022/10/21.
//

import SwiftUI
import SplatNet3

struct WaveChartView: View {
//    let data: Grizzco.Chart.Wave

//    func NormalWave() -> some View {
//        ForEach(EventType.allCases, content: { eventType in
//            VStack(alignment: .leading, spacing: 2, content: {
//                Text(eventType.localizedText)
//                    .font(systemName: .Splatfont2, size: 13)
//                HStack(spacing: 0, content: {
//                    ForEach(WaterType.allCases, content: { waterLevel in
//                        if let entry: Grizzco.Chart.Wave.WaveEntry = data.entries.first(where: { $0.eventType == eventType && $0.waterLevel == waterLevel }) {
//                            WaveContent(entry: entry)
//                                .hidden(!entry.isAvailable)
//                        } else {
//                            EmptyView()
//                        }
//                    })
//                })
//            })
//        })
//    }

//    func ExtraWave() -> some View {
//        VStack(alignment: .leading, spacing: 2, content: {
//            Text(bundle: .CoopHistory_ExWave)
//                .font(systemName: .Splatfont2, size: 13)
//            HStack(spacing: 0, content: {
//                ForEach(WaterType.allCases, content: { waterLevel in
//                    if let entry: Grizzco.Chart.Wave.WaveEntry = data.extra.first(where: { $0.eventType == nil && $0.waterLevel == waterLevel }) {
//                        WaveContent(entry: entry)
//                            .hidden(!entry.isAvailable)
//                    } else {
//                        EmptyView()
//                    }
//                })
//            })
//        })
//    }

    var body: some View {
        EmptyView()
//        ScrollView(content: {
//            LazyVStack(pinnedViews: .sectionHeaders, content: {
//                Section(content: {
//                    NormalWave()
//                    ExtraWave()
//                }, header: {
//                    HStack(spacing: 0, content: {
//                        ForEach(WaterType.allCases, content: { waterLevel in
//                            WaveTideContent(waterLevel: waterLevel)
//                        })
//                    })
//                })
//            })
//        })
    }
}

private struct WaveTideContent: View {
    let waterLevel: WaterType

    var body: some View {
        ZStack(content: {
            Rectangle()
                .fill(SPColor.SplatNet3.SPBlue.opacity(0.7))
            Rectangle()
                .stroke(Color.black, lineWidth: 1)
            Text(waterLevel.localizedText)
                .font(systemName: .Splatfont2, size: 13)
                .foregroundColor(.white)
        })
        .frame(width: 110, height: 20)
    }
}

private struct WaveContent: View {
//    let entry: Grizzco.Chart.Wave.WaveEntry
//
//    init(entry: Grizzco.Chart.Wave.WaveEntry) {
//        self.entry = entry
//    }
//
//    func Count() -> some View {
//        Text(String(format: "%2d/%2d", entry.clear, entry.count))
//            .font(systemName: .Splatfont2, size: 12)
//            .foregroundColor(.white)
//            .padding(.horizontal, 4)
//            .background(.black)
//    }
//
//    func Percent() -> some View {
//        GeometryReader(content: { geometry in
//            HStack(spacing: 0, content: {
//                let clearRatio: Double = entry.clearRatio ?? .zero
//                Rectangle()
//                    .fill(SPColor.SplatNet3.SPOrange)
//                    .frame(width: geometry.width * clearRatio / 100)
//                Rectangle()
//                    .fill(Color.gray)
//                    .frame(width: geometry.width * (1 - clearRatio / 100))
//            })
//            .overlay(Text(String(format: "%.1f%%", entry.clearRatio)).shadow(color: .black, radius: 0, x: 1, y: 1))
//            .font(systemName: .Splatfont2, size: 12)
//            .foregroundColor(.white)
//        })
//        .frame(height: 12)
//        .padding(.horizontal, 4)
//        .padding(.bottom, 4)
//    }

    var body: some View {
        EmptyView()
//        ZStack(content: {
//            Rectangle()
//                .fill(Color(hex: "D9D9D9"))
//            Rectangle()
//                .stroke(Color.gray, lineWidth: 1)
//        })
//        .overlay(Count(), alignment: .topTrailing)
//        .overlay(Percent(), alignment: .bottom)
//        .frame(width: 110, height: 40)
    }
}

//struct WaveChart_Previews: PreviewProvider {
//    static var previews: some View {
//        NavigationView(content: {
//            WaveChartView()
//                .navigationBarTitleDisplayMode(.inline)
//                .navigationTitle(Text(bundle: .Blaster_LightLong_00))
//        })
//    }
//}
