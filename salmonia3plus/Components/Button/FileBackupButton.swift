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

    func deleteJSON() {
        guard let baseURL: URL = try? FileManager.default.url(for: .cachesDirectory, in: .userDomainMask, appropriateFor: nil, create: false),
              let documentURLs: [URL] = try? FileManager.default.contentsOfDirectory(at: baseURL, includingPropertiesForKeys: nil)
        else {
            return
        }
        /// バックアップファイル
        let documents: [URL] = documentURLs.filter({
            $0.pathExtension == "json" &&
            !$0.lastPathComponent.capture(pattern: #"[0-9]{14}"#).isEmpty
        })
        /// これらは要らないので削除する
        for document in documents {
            if FileManager.default.fileExists(atPath: document.path) {
                try? FileManager.default.removeItem(atPath: document.path)
            }
        }
    }

    func exportJSON(compress: Bool) {
        Task  {
            do {
                let destination: URL = try await RealmService.shared.exportJSON(compress: compress)
                let activity: UIActivityViewController = await UIActivityViewController(activityItems: [destination], applicationActivities: nil)
                await UIApplication.shared.presentedViewController?.popover(activity, animated: true)
            } catch(let error) {
                let alert: UIAlertController = await UIAlertController(title: LocalizedType.Error_Error.localized, message: error.localizedDescription, preferredStyle: .alert)
                let action: UIAlertAction = await UIAlertAction(title: LocalizedType.Common_Decide.localized, style: .default)
                await alert.addAction(action)
                await UIApplication.shared.presentedViewController?.present(alert, animated: true)
            }
        }
    }

    var body: some View {
        Button(action: {
            isPresented.toggle()
        }, label: {
            Text(bundle: .Custom_Backup)
        })
        .confirmationDialog(
            Text(bundle: .Custom_Backup),
            isPresented: $isPresented,
            titleVisibility: .visible,
            actions: {
            Button(action: {
                exportJSON(compress: true)
            }, label: {
                Text(bundle: .Custom_Backup_Compress)
            })
            Button(action: {
                exportJSON(compress: false)
            }, label: {
                Text(bundle: .Custom_Backup_No_Compress)
            })
        }, message: {
            Text(bundle: .Custom_Backup_Txt)
        })
    }
}

struct FileBackupButton_Previews: PreviewProvider {
    static var previews: some View {
        FileBackupButton()
    }
}
