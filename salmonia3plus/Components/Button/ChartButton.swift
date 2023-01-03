//
//  ChartButton.swift
//  Salmonia3+
//  
//  Created by devonly on 2023/01/03
//  Copyright © 2023 Magi Corporation. All rights reserved.
//

import SwiftUI
import SplatNet3

struct ChartButton: View {
    @State private var isPresented: Bool = false

    var body: some View {
        Button(action: {
            isPresented.toggle()
        }, label: {
            Image(icon: .Squid)
                .resizable()
        })
        .buttonStyle(SPButtonStyle(title: .Custom_Write_Review, color: SPColor.SplatNet3.SPPink))
        .overlay(content: {
            NavigationLink(isActive: $isPresented, destination: {
                EnemyChartView()
            }, label: {
                EmptyView()
            })
        })
    }
}

struct ChartButton_Previews: PreviewProvider {
    static var previews: some View {
        ChartButton()
    }
}
