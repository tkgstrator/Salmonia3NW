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
    let contentId: ContentId

    var body: some View {
        Button(action: {
            isPresented.toggle()
        }, label: {
            Image(icon: .Switch)
                .resizable()
        })
        .buttonStyle(SPButtonStyle(title: .Common_Sign_In, color: contentId == .SP3 ? SPColor.SplatNet3.SPBlue : SPColor.SplatNet2.SPRed))
        .authorize(isPresented: $isPresented, contentId: contentId)
    }
}

struct SignInButton_Previews: PreviewProvider {
    static var previews: some View {
        SignInButton(contentId: .SP3)
    }
}
