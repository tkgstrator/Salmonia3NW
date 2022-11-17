//
//  GrizzcoRateView.swift
//  Salmonia3+
//
//  Created by devonly on 2022/11/15.
//

import SwiftUI
import SplatNet3

struct GrizzcoRateView: View {
    @ObservedObject var data: Grizzco.RateData

    var body: some View {
        if #available(iOS 16.0, *) {
            ChartView(destination: {
                RateChartView(chart: data.ikuraNum)
            }, content: {
                GrizzcoRateContent()
            })
        } else {
            GrizzcoRateContent()
        }
    }
}

private struct GrizzcoRateContent: View {
    var body: some View {
        ZStack(alignment: .center, content: {
            Color.black.opacity(0.7)
            VStack(spacing: 0, content: {
                Text(bundle: .Common_Supplied_Main_Prob)
                    .font(systemName: .Splatfont, size: 12)
                    .frame(maxWidth: .infinity, height: 12, alignment: .leading)
                    .padding(.vertical, 6)
                    .padding(.horizontal, 10)
                VStack(alignment: .leading, content: {
                    Label(title: {}, icon: {
                        Image(bundle: .GoldenIkura)
                            .resizable()
                            .scaledToFit()
                            .frame(width: 22, height: 16)
                    })
                    Label(title: {}, icon: {
                        Image(bundle: .Ikura)
                            .resizable()
                            .scaledToFit()
                            .frame(width: 22, height: 16)
                    })
                    Label(title: {}, icon: {
                        Image(bundle: .Salmon)
                            .renderingMode(.template)
                            .resizable()
                            .scaledToFit()
                            .foregroundColor(SPColor.SplatNet3.SPSalmonOrange)
                            .frame(width: 24, height: 20)
                    })
                })
                .minimumScaleFactor(0.8)
                .padding(8)
            })
        })
        .foregroundColor(SPColor.SplatNet3.SPSalmonGreen)
        .font(systemName: .Splatfont2, size: 13)
        .cornerRadius(10, corners: .allCorners)
    }
}

//struct GrizzcoRateView_Previews: PreviewProvider {
//    static var previews: some View {
//        GrizzcoRateView()
//            .maxWidth(197.5)
//    }
//}
