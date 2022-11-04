//
//  PickerStyle.swift
//  Salmonia3+
//
//  Created by tkgstrator on 2022/11/04.
//  
//

import SwiftUI
import SplatNet3

struct PickerStyle_Previews: PreviewProvider {
    @State private static var selection: Int? = 0

    static var previews: some View {
        Picker(selection: $selection, content: {
            Text("SplatNet1")
            Text("SplatNet2")
            Text("SplatNet3")
        }, label: {
            Text(bundle: .CoopHistory_Limited)
        })
    }
}
