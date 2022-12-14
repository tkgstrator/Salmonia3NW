//
//  GamingToggle.swift
//  Salmonia3+
//  
//  Created by devonly on 2022/12/09
//  Copyright © 2022 Magi Corporation. All rights reserved.
//

import SwiftUI
import SplatNet3

struct GamingToggle: View {
    @State private var isPresented: Bool = false

    var body: some View {
        Toggle(isOn: $isPresented, label: {
            Text(bundle: .Custom_Gaming_Mode)
        })
    }
}

struct GamingToggle_Previews: PreviewProvider {
    static var previews: some View {
        GamingToggle()
    }
}
