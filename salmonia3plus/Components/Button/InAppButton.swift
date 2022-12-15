//
//  InAppButton.swift
//  Salmonia3+
//  
//  Created by devonly on 2022/12/04
//  Copyright © 2022 Magi Corporation. All rights reserved.
//

import SwiftUI
import SplatNet3

public enum InAppBrowser {
    struct WebView: View {
        @State private var isPresented: Bool = false
        let contentId: ContentId

        var body: some View {
            Button(action: {
                isPresented.toggle()
            }, label: {
                Image(logo: contentId == .SP3 ? .Logo3 : .Logo2)
                    .resizable()
                    .scaledToFit()
            })
            .buttonStyle(SPWebButtonStyle(
                title: contentId == .SP3 ? .Common_Ikaring3 : .Custom_Ikaring2,
                color: SPColor.SplatNet3.SPBlue
            ))
            .openInAppBrowser(isPresented: $isPresented, contentId: contentId)
        }
    }
}

struct InAppButton_Previews: PreviewProvider {
    static var previews: some View {
        InAppBrowser.WebView(contentId: .SP3)
    }
}
