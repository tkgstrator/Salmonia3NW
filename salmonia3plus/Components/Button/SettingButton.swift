//
//  SettingButton.swift
//  Salmonia3+
//  
//  Created by devonly on 2022/12/10
//  Copyright © 2022 Magi Corporation. All rights reserved.
//

import SwiftUI
import SplatNet3

struct SettingButton: View {
    @State private var isPresented: Bool = false

    var body: some View {
        Button(action: {
            isPresented.toggle()
        }, label: {
            Image(icon: .Gear)
                .resizable()
                .scaledToFit()
        })
        .buttonStyle(SPButtonStyle(title: .Settings_Title, color: SPColor.SplatNet2.SPGreen))
        .sheet(isPresented: $isPresented, content: {
            _MenuView()
        })
    }
}

struct SettingButton_Previews: PreviewProvider {
    static var previews: some View {
        SettingButton()
    }
}
