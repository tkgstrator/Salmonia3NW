//
//  DeleteButton.swift
//  Salmonia3+
//  
//  Created by devonly on 2022/11/27
//  Copyright © 2022 Magi Corporation. All rights reserved.
//

import SwiftUI
import SplatNet3

struct DeleteButton: View {
    @State private var isPresented: Bool = false

    var body: some View {
        Button(action: {
            isPresented.toggle()
        }, label: {
            Image(icon: .Defeated)
                .resizable()
        })
        .buttonStyle(SPButtonStyle(title: .Common_Wipe_Results, color: SPColor.SplatNet3.SPPink))
        .confirmationDialog(
            Text(bundle: .Common_Wipe_Results),
            isPresented: $isPresented,
            titleVisibility: .visible,
            actions: {
            Button(action: {
                Task {
                    await RealmService.shared.deleteAll()
                }
            }, label: {
                Text("OK")
            })
        }, message: {
            Text(bundle: .Common_Wipe_Results_Txt)
        })
    }
}

struct DeleteButton_Previews: PreviewProvider {
    static var previews: some View {
        DeleteButton()
    }
}
