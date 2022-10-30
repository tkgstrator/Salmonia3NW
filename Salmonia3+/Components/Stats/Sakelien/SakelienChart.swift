//
//  SakelienChart.swift
//  Salmonia3+
//
//  Created by devonly on 2022/10/21.
//

import SwiftUI
import SplatNet3

struct SakelienChart: View {
    let sakelienId: SakelienType

    var body: some View {
        ZStack(alignment: .top, content: {
            Image(bundle: .MOCK)
                .renderingMode(.template)
                .resizable()
                .scaledToFit()
                .foregroundColor(Color.black.opacity(0.7))
            VStack(alignment: .leading, spacing: 0, content: {
                Image(bundle: sakelienId)
                    .resizable()
                    .scaledToFit()
                    .frame(width: 24, height: 24, alignment: .center)
                    .frame(maxWidth: .infinity, alignment: .leading)
                Spacer()
                ZStack(alignment: .center, content: {
                    let randomValue: Double = Double.random(in: 0...1)
                    GeometryReader(content: { geometry in
                        Rectangle()
                            .fill(Color.white.opacity(0.3))
                        Rectangle()
                            .fill(SPColor.SplatNet3.SPBlue)
                            .frame(width: geometry.width * randomValue)
                    })
                    Text(String(format: "%.2f%%", randomValue * 100))
                        .shadow(color: Color.black, radius: 0, x: 1, y: 1)
                })
                .frame(height: 10)
                .clipShape(RoundedRectangle(cornerRadius: 6))
                .padding(.bottom, 8)
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
            .padding(.all, 4)
        })
        .cornerRadius(10)
    }
}

struct SakelienChart_Previews: PreviewProvider {
    static var previews: some View {
        ScrollView(content: {
            LazyVGrid(columns: Array(repeating: .init(.flexible(minimum: 80, maximum: 120)), count: 3), content: {

                ForEach(SakelienType.allCases, id: \.hashValue) { sakelienId in
                    SakelienChart(sakelienId: sakelienId)
                }
            })
        })
        .preferredColorScheme(.dark)
        .backgroundForResult()
    }
}
