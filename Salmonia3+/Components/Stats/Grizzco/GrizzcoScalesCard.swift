//
//  GrizzcoScalesCard.swift
//  Salmonia3+
//
//  Created by tkgstrator on 2022/10/19.
//

import SwiftUI
import SplatNet3

struct GrizzcoScaleView: View {
    @ObservedObject var data: Grizzco.Chart.Scale

    var body: some View {
        if #available(iOS 16.0, *), false {
            ChartView(destination: {
                EmptyView()
            }, content: {
                GrizzcoScaleContent(data: data)
            })

        } else {
            GrizzcoScaleContent(data: data)
        }
    }
}

private struct GrizzcoScaleContent: View {
    @ObservedObject var data: Grizzco.Chart.Scale

    var body: some View {
        ZStack(alignment: .center, content: {
            Color.black.opacity(0.7)
            VStack(alignment: .leading, spacing: 0, content: {
                Text(bundle: .CoopHistory_Scale)
                    .font(systemName: .Splatfont, size: 12)
                    .frame(maxWidth: .infinity, height: 12, alignment: .leading)
                LazyVGrid(columns: Array(repeating: .init(.fixed(34)), count: 3), content: {
                    VStack(alignment: .center, spacing: 0, content: {
                        Image(bundle: ScaleType.Bronze)
                            .resizable()
                            .scaledToFit()
                            .frame(width: 25, height: 25, alignment: .center)
                        Text(String(format: "x%d", data.bronze))
                            .padding(.top, 2)
                    })
                    VStack(alignment: .center, spacing: 0, content: {
                        Image(bundle: ScaleType.Silver)
                            .resizable()
                            .scaledToFit()
                            .frame(width: 25, height: 25, alignment: .center)
                        Text(String(format: "x%d", data.silver))
                            .padding(.top, 2)
                    })
                    VStack(alignment: .center, spacing: 0, content: {
                        Image(bundle: ScaleType.Gold)
                            .resizable()
                            .scaledToFit()
                            .frame(width: 25, height: 25, alignment: .center)
                        Text(String(format: "x%d", data.gold))
                            .padding(.top, 2)
                    })
                })
                .padding(.top, 8)
                .padding(.bottom, 2)
            })
            .padding(.vertical, 6)
            .padding(.horizontal, 10)
        })
        .foregroundColor(SPColor.SplatNet3.SPSalmonGreen)
        .font(systemName: .Splatfont2, size: 12)
        .cornerRadius(10, corners: .allCorners)
    }
}
