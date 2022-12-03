//
//  SignInButton.swift
//  Salmonia3+
//  
//  Created by devonly on 2022/11/27
//  Copyright © 2022 Magi Corporation. All rights reserved.
//

import SwiftUI
import SplatNet3

struct SignInButton: View {
    @State private var isPresented: Bool = false

    var body: some View {
        Button(action: {
            isPresented.toggle()
        }, label: {
            Image(icon: .Switch)
                .resizable()
        })
        .buttonStyle(SPButtonStyle(title: .Common_Sign_In, color: SPColor.SplatNet3.SPRed))
        .authorize(isPresented: $isPresented, contentId: .SP3)
    }
}

struct SignInButton_Previews: PreviewProvider {
    static var previews: some View {
        SignInButton()
    }
}
