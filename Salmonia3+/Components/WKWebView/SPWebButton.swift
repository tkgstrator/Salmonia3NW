//
//  SPWebButton.swift
//  Salmonia3+
//
//  Created by devonly on 2022/10/20.
//

import SwiftUI

struct SPWebButton: View {
    @State private var isPresented: Bool = false

    var body: some View {
        Button(action: {
            isPresented.toggle()
        }, label: {
            Image(bundle: .Switch)
                .renderingMode(.template)
                .resizable()
                .scaledToFit()
                .frame(width: 30, height: 30, alignment: .center)
                .foregroundColor(.primary)
        })
        .fullScreenCover(isPresented: $isPresented, content: {
            SPWebView()
                .preferredColorScheme(.dark)
        })
    }
}

struct SPWebButton_Previews: PreviewProvider {
    static var previews: some View {
        SPWebButton()
    }
}
