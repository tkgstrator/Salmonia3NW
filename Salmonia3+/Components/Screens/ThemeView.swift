//
//  ThemeView.swift
//  Salmonia3+
//
//  Created by tkgstrator on 2022/09/23.
//

import SwiftUI
import SplatNet3

/// アプリの見た目などを変更します
struct ThemeView: View {
    @State private var isPresented: Bool = false
    var body: some View {
        List(content: {
            ThemeToggle(bundle: .L_BtnOption_07_T_Header_00)
        })
        .backgroundForResult()
        .listStyle(.plain)
        .navigationBarTitleDisplayMode(.inline)
        .navigationTitle(Text(bundle: .L_Bottom_05_T_Info_00))
    }
}

private struct ThemeToggle: View {
    @State private var isPresented: Bool = false
    let bundle: LocalizedType

    var body: some View {
        Toggle(isOn: $isPresented, label: {
            Text(bundle: bundle)
                .font(systemName: .Splatfont2, size: 16)
        })
        .toggleStyle(.splatoon)
        .listRowBackground(Color.clear)
    }
}

struct ThemeView_Previews: PreviewProvider {
    static var previews: some View {
        ThemeView()
    }
}
