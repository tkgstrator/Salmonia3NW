//
//  UnlinkButton.swift
//  Salmonia3+
//  
//  Created by devonly on 2022/12/09
//  Copyright © 2022 Magi Corporation. All rights reserved.
//

import SwiftUI
import SplatNet3

struct UnlinkButton: View {
    @StateObject var session: Session = Session()
    @State private var isPresented: Bool = false

    var body: some View {
        Button(role: .destructive, action: {
            isPresented.toggle()
        }, label: {
            Text(bundle: .Custom_Sign_Out)
        })
        .confirmationDialog(Text(bundle: .Custom_Sign_Out), isPresented: $isPresented, titleVisibility: .visible, actions: {
            Button(role: .destructive, action: {
                session.removeAll()
            }, label: {
                Text(bundle: .Custom_Sign_Out)
            })
        }, message: {
            Text(bundle: .Custom_Sign_Out_Txt)
        })
    }
}

struct UnlinkButton_Previews: PreviewProvider {
    static var previews: some View {
        UnlinkButton()
    }
}
