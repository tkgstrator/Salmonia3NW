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
    @State private var dataFormatType: FormatType = .SALMONIA3

    var body: some View {
        Button(action: {
            isPresented.toggle()
        }, label: {
            Text(bundle: .Custom_Restore)
        })
        .confirmationDialog(Text(bundle: .Custom_Restore), isPresented: $isPresented, titleVisibility: .visible, actions: {
            Button(action: {
                dataFormatType = .SALMONIA3
                isSelected.toggle()
            }, label: {
                Text("Salmonia3+")
            })
            Button(action: {
                dataFormatType = .SPLATNET3
                isSelected.toggle()
            }, label: {
                Text("SplatNet3")
            })
        }, message: {
            Text(bundle: .Custom_Restore_Txt)
        })
        .sheet(isPresented: $isSelected, content: {
            FilePickerView(fileType: [.json, .zip], onSelected: { url in
                UIApplication.shared.startAnimating(
                    completion: {
                        do {
                            let resultCounts: Int = try RealmService.shared.openURL(url: url, format: dataFormatType)
                            let alert: UIAlertController = UIAlertController(title: "*復元成功*", message: "*\(resultCounts)件のリザルト復元に成功した*", preferredStyle: .alert)
                            let action: UIAlertAction = UIAlertAction(title: LocalizedType.Common_Decide.localized, style: .default)
                            alert.addAction(action)
                            UIApplication.shared.presentedViewController?.present(alert, animated: true)
                        } catch {
                            SwiftyLogger.error(error)
                            let alert: UIAlertController = UIAlertController(title: LocalizedType.Error_Error.localized, message: error.localizedDescription, preferredStyle: .alert)
                            let action: UIAlertAction = UIAlertAction(title: LocalizedType.Common_Decide.localized, style: .default)
                            alert.addAction(action)
                            UIApplication.shared.presentedViewController?.present(alert, animated: true)
                        }
                    })
            })
        })
    }
}

struct FilePickerButton_Previews: PreviewProvider {
    static var previews: some View {
        FilePickerButton()
    }
}
