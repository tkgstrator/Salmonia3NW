//
//  Rainbow.swift
//  Salmonia3+
//
//  Created by tkgstrator on 2022/10/29.
//

import SwiftUI

struct Rainbow: View {
    let colors = stride(from: 0, to: 1, by: 0.01).map({ Color(hue: $0, saturation: 1, brightness: 1) })

    var body: some View {
        LinearGradient(gradient: Gradient(colors: colors), startPoint: .leading, endPoint: .trailing)
    }
}

struct Rainbow_Previews: PreviewProvider {
    static var previews: some View {
        Rainbow()
    }
}
