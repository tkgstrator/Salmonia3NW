//
//  ReviewButton.swift
//  Salmonia3+
//  
//  Created by devonly on 2022/12/21
//  Copyright © 2022 Magi Corporation. All rights reserved.
//

import SwiftUI
import SplatNet3

struct ReviewButton: View {
    @State private var isPresented: Bool = false

    var body: some View {
        Button(action: {
            isPresented.toggle()
        }, label: {
            Image(icon: .Squid)
                .resizable()
        })
        .buttonStyle(SPButtonStyle(title: .Custom_Write_Review, color: SPColor.SplatNet3.SPPink))
    }
}

struct ReviewButton_Previews: PreviewProvider {
    static var previews: some View {
        ReviewButton()
    }
}
