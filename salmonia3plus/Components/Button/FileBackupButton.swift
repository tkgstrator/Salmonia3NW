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
            isPresented.toggle()
        }, label: {
            Image(icon: .Swap)
                .resizable()
        })
        .buttonStyle(SPButtonStyle(title: .Common_Backup, color: SPColor.SplatNet3.SPLeague))
        .confirmationDialog(
            Text(bundle: .Common_Backup),
            isPresented: $isPresented,
            titleVisibility: .visible,
            actions: {
            Button(action: {
                Task {
                    let destination: URL = try await RealmService.shared.exportJSON(compress: true)
                    let activity: UIActivityViewController = UIActivityViewController(activityItems: [destination], applicationActivities: nil)
                    UIApplication.shared.rootViewController?.popover(activity, animated: true)
                }
            }, label: {
                Text(bundle: .Common_Backup_Compress)
            })
            Button(action: {
                Task {
                    let destination: URL = try await RealmService.shared.exportJSON(compress: false)
                    let activity: UIActivityViewController = UIActivityViewController(activityItems: [destination], applicationActivities: nil)
                    UIApplication.shared.rootViewController?.popover(activity, animated: true)
                }
            }, label: {
                Text(bundle: .Common_Backup_No_Compress)
            })
        }, message: {
            Text(bundle: .Common_Backup_Txt)
        })
    }
}

struct FileBackupButton_Previews: PreviewProvider {
    static var previews: some View {
        FileBackupButton()
    }
}
