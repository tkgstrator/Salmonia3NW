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
        .buttonStyle(SPButtonStyle(title: .Common_Share, color: SPColor.SplatNet3.SPLeague))
        .confirmationDialog(
            Text("バックアップ"),
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
                Text("圧縮(ZIP)")
            })
            Button(action: {
                Task {
                    let destination: URL = try await RealmService.shared.exportJSON(compress: false)
                    let activity: UIActivityViewController = UIActivityViewController(activityItems: [destination], applicationActivities: nil)
                    UIApplication.shared.rootViewController?.popover(activity, animated: true)
                }
            }, label: {
                Text("非圧縮(JSON)")
            })
        }, message: {
            Text("リザルトのバックアップを行います")
        })
    }
}

struct FileBackupButton_Previews: PreviewProvider {
    static var previews: some View {
        FileBackupButton()
    }
}
