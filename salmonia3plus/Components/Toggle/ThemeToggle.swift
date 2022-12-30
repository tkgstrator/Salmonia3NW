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
    @AppStorage(SceneKey.colorScheme.rawValue) var colorScheme: UIUserInterfaceStyle = .dark

    var body: some View {
        Toggle(isOn: Binding(get: {
            colorScheme == .dark
        }, set: { newValue in
            colorScheme = newValue ? .dark : .light
        }), label: {
            Text(bundle: .Custom_Dark_Mode)
        })
    }
}

struct ThemeToggle_Previews: PreviewProvider {
    static var previews: some View {
        ThemeToggle()
    }
}
