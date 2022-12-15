//
//  LogDeleteButton.swift
//  Salmonia3+
//  
//  Created by devonly on 2022/12/15
//  Copyright © 2022 Magi Corporation. All rights reserved.
//

import SwiftUI
import SplatNet3

struct LogDeleteButton: View {
    @State private var isPresented: Bool = false

    var body: some View {
        Button(role: .destructive, action: {
            isPresented.toggle()
        }, label: {
            Text(bundle: .Custom_Wipe_Log)
        })
        .confirmationDialog(
            Text(bundle: .Custom_Wipe_Log),
            isPresented: $isPresented,
            titleVisibility: .visible,
            actions: {
                Button(action: {
                    SwiftyLogger.deleteAll()
                }, label: {
                Text(bundle: .Common_Decide)
            })
        }, message: {
            Text(bundle: .Custom_Wipe_Log_Txt)
        })
    }
}

struct LogDeleteButton_Previews: PreviewProvider {
    static var previews: some View {
        LogDeleteButton()
    }
}
