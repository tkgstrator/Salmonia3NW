//
//  FilePickerButton.swift
//  Salmonia3+
//
//  Created by devonly on 2022/11/22.
//

import SwiftUI
import SplatNet3

struct FilePickerButton: View {
    @State private var isPresented: Bool = false
    @State private var isSelected: Bool = false
    @State private var dateDecodingStrategy: JSONDecoder.DateDecodingStrategy = .deferredToDate
    @Environment(\.dismiss) var dismiss

    var body: some View {
        Button(action: {
            isPresented.toggle()
        }, label: {
            Image(icon: .Refresh)
                .resizable()
        })
        .buttonStyle(SPButtonStyle(title: .Common_Restore, color: SPColor.SplatNet3.SPBlue))
        .confirmationDialog(Text(bundle: .Common_Restore), isPresented: $isPresented, titleVisibility: .visible, actions: {
            Button(action: {
                dateDecodingStrategy = .iso8601
                isSelected.toggle()
            }, label: {
                Text("ISO8601")
            })
            Button(action: {
                dateDecodingStrategy = .secondsSince1970
                isSelected.toggle()
            }, label: {
                Text("SecondsSince1970")
            })
            Button(action: {
                dateDecodingStrategy = .deferredToDate
                isSelected.toggle()
            }, label: {
                Text("DeferredToDate")
            })
        }, message: {
            Text(bundle: .Common_Restore_Txt)
        })
        .sheet(isPresented: $isSelected, content: {
            FilePickerView(fileType: .json, onSelected: { url in
                Task {
                    do {
                        try await RealmService.shared.openURL(url: url, decoding: dateDecodingStrategy)
                        dismiss()
                    } catch(let error) {
                        SwiftyLogger.error(error.localizedDescription)
                        let alert: UIAlertController = UIAlertController(title: "読み込み失敗しました", message: error.localizedDescription, preferredStyle: .alert)
                        let action: UIAlertAction = UIAlertAction(title: LocalizedType.Common_Close.localized, style: .default)
                        alert.addAction(action)
                        UIApplication.shared.rootViewController?.present(alert, animated: true)
                    }
                }
            })
        })
    }
}

struct FilePickerButton_Previews: PreviewProvider {
    static var previews: some View {
        FilePickerButton()
    }
}
