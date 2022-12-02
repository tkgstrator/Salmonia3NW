//
//  FileBackupButton.swift
//  salmonia3plus
//
//  Created by devonly on 2022/11/22.
//  Copyright © 2022 Magi Corporation. All rights reserved.
//

import SwiftUI

struct FileBackupButton: View {
    @State private var isPresented: Bool = false

    var body: some View {
        Button(action: {
            isPresented.toggle()
        }, label: {
            Text("Backup")
        })
    }
}

struct FileBackupButton_Previews: PreviewProvider {
    static var previews: some View {
        FileBackupButton()
    }
}
