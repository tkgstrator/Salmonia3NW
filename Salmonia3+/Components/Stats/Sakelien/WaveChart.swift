//
//  WaveChart.swift
//  Salmonia3+
//
//  Created by tkgstrator on 2022/10/21.
//

import SwiftUI
import SplatNet3

struct WaveChartView: View {
    var body: some View {
        List(content: {
            ForEach(EventType.allCases, content: { eventType in
                WaveChartContent(eventType: eventType)
                    .listRowSeparator(.hidden)
                    .listSectionSeparator(.hidden)
            })
        })
        .listStyle(.plain)
    }
}

struct WaveChartContent: View {
    let eventType: EventType

    var body: some View {
        HStack(spacing: 0, content: {
            WaveContent()
            WaveContent()
            WaveContent()
        })
    }
}

struct WaveContent: View {
    let clear: Int
    let appear: Int

    init() {
        let minValue: Int = Int.random(in: 0...50)
        self.clear = minValue
        self.appear = Int.random(in: minValue...50)
    }

    func Count(clear: Int, appear: Int) -> some View {
        Text(String(format: "%2d/%2d", clear, appear))
            .font(systemName: .Splatfont2, size: 12)
            .foregroundColor(.white)
            .padding(.horizontal, 4)
            .background(.black)
    }

    func Percent(clear: Int, appear: Int) -> some View {
        let percent: Double = {
            if appear == .zero {
                return .zero
            }
            return Double(clear) / Double(appear)
        }()
        return GeometryReader(content: { geometry in
            HStack(spacing: 0, content: {
                Rectangle()
                    .fill(SPColor.SplatNet3.SPOrange)
                    .frame(width: geometry.width * percent)
                Rectangle()
                    .fill(Color.gray)
                    .frame(width: geometry.width * (1 - percent))
            })
            .overlay(Text(String(format: "%.1f%%", percent * 100)))
            .font(systemName: .Splatfont2, size: 12)
        })
        .frame(height: 12)
        .padding(.horizontal, 4)
        .padding(.bottom, 4)
    }

    var body: some View {
        ZStack(content: {
            Rectangle()
                .fill(Color(hex: "D9D9D9"))
            Rectangle()
                .strokeBorder(.black, lineWidth: 1)
        })
        .overlay(Count(clear: self.clear, appear: self.appear), alignment: .topTrailing)
        .overlay(Percent(clear: clear, appear: appear), alignment: .bottom)
        .frame(width: 110, height: 40)
    }
}

struct WaveChart_Previews: PreviewProvider {
    static var previews: some View {
        NavigationView(content: {
            WaveChartView()
                .navigationBarTitleDisplayMode(.inline)
                .navigationTitle(Text(bundle: .Blaster_LightLong_00))
        })
    }
}
