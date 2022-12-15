//
//  UserButton.swift
//  Salmonia3+
//  
//  Created by devonly on 2022/12/15
//  Copyright © 2022 Magi Corporation. All rights reserved.
//

import SwiftUI
import SplatNet3
import SDWebImageSwiftUI

struct UserButton: View {
    @EnvironmentObject var session: Session

    var body: some View {
        Button(action: {
        }, label: {
            WebImage(url: session.account?.thumbnailURL)
                .resizable()
                .scaledToFit()
        })
        .disabled(true)
        .buttonStyle(SPWebButtonStyle(title: session.account?.nickname, color: SPColor.SplatNet3.SPCoop))
    }
}

struct UserButton_Previews: PreviewProvider {
    static var previews: some View {
        UserButton()
    }
}
