//
//  FileBackupButton.swift
//  salmonia3plus
//
//  Created by devonly on 2022/11/22.
//  Copyright © 2022 Magi Corporation. All rights reserved.
//

import SwiftUI
import SplatNet3

struct FileBackupButton: View {
    @State private var isPresented: Bool = false

    var body: some View {
        Button(action: {
            Task {
                do {
                    let destination: URL = try await RealmService.shared.exportJSON()
                    let activity: UIActivityViewController = UIActivityViewController(activityItems: [destination], applicationActivities: nil)
                    UIApplication.shared.rootViewController?.popover(activity, animated: true)
                } catch(let error) {
                    print(error)
                }
            }
        }, label: {
            Image(icon: .Swap)
                .resizable()
        })
        .buttonStyle(SPButtonStyle(title: .Common_Share, color: SPColor.SplatNet3.SPLeague))
    }
}

struct FileBackupButton_Previews: PreviewProvider {
    static var previews: some View {
        FileBackupButton()
    }
}
