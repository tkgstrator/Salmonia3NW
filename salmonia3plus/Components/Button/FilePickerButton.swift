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
    @Environment(\.dismiss) var dismiss

    var body: some View {
        Button(action: {
            isPresented.toggle()
        }, label: {
            Image(icon: .Refresh)
                .resizable()
        })
        .buttonStyle(SPButtonStyle(title: .Common_Share, color: SPColor.SplatNet3.SPBlue))
        .confirmationDialog(Text("Import Data"), isPresented: $isPresented, titleVisibility: .visible, actions: {
            Button(action: {
                isSelected.toggle()
            }, label: {
                Text("Select File")
            })
        }, message: {
            Text("You can share from other apps or select from\n Files app.")
        })
        .sheet(isPresented: $isSelected, content: {
            FilePickerView(fileType: .json, onSelected: { url in
                dismiss()
            })
        })
    }
}

struct FilePickerButton_Previews: PreviewProvider {
    static var previews: some View {
        FilePickerButton()
    }
}
