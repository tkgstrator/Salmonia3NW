//
//  ThemeToggle.swift
//  Salmonia3+
//  
//  Created by devonly on 2022/12/09
//  Copyright © 2022 Magi Corporation. All rights reserved.
//

import SwiftUI
import SplatNet3

struct ThemeToggle: View {
    @Environment(\.preferredColorScheme) var colorScheme

    var body: some View {
        Toggle(isOn: Binding(
            get: { colorScheme.wrappedValue == .dark },
            set: { colorScheme.wrappedValue = $0 ? .dark : .light }
        ), label: {
            Text(bundle: .Custom_Dark_Mode)
        })
    }
}

struct ThemeToggle_Previews: PreviewProvider {
    static var previews: some View {
        ThemeToggle()
    }
}
