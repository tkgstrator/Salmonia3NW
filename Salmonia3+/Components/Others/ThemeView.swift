//
//  ThemeView.swift
//  Salmonia3+
//
//  Created by devonly on 2022/09/23.
//

import SwiftUI

/// アプリの見た目などを変更します
struct ThemeView: View {
    var body: some View {
        ScrollView(content: {
            LazyVGrid(columns: Array(repeating: .init(.flexible(maximum: 360)), count: 1), content: {
                NSOToggle.ColorScheme()
                #if DEBUG
                NSOToggle.BackgroundImage()
                NSOToggle.RotaionEffect()
                #endif
            })
            .padding(.horizontal)
        })
        .navigationTitle(Text(localizedText: "TITLE_APPEARANCE"))
    }
}

struct ThemeView_Previews: PreviewProvider {
    static var previews: some View {
        ThemeView()
    }
}
