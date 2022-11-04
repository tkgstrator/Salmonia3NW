//
//  ThemeView.swift
//  Salmonia3+
//
//  Created by tkgstrator on 2022/09/23.
//

import SwiftUI

/// アプリの見た目などを変更します
struct ThemeView: View {
    @State private var isPresented: Bool = false
    var body: some View {
        List(content: {
            Toggle(isOn: $isPresented, label: {
                Text(bundle: .Catalog_Point)
            })
            .toggleStyle(.splatoon)
        })
        .listStyle(.plain)
        .navigationBarTitleDisplayMode(.inline)
        .navigationTitle(Text(localizedText: "TITLE_APPEARANCE"))
    }
}

struct ThemeView_Previews: PreviewProvider {
    static var previews: some View {
        ThemeView()
    }
}
