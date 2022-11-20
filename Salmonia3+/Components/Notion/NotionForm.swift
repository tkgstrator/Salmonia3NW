//
//  NotionForm.swift
//  Salmonia3+
//
//  Created by devonly on 2022/11/20.
//

import SwiftUI

struct NotionForm: View {
    @Environment(\.dismiss) var dismiss
    @StateObject private var session: NotionService = NotionService()
    @State private var title: String = ""
    @State private var content: String = ""
    @State private var selection: TagType = .バグ修正
    @State private var isEditing: Bool = false

    func disabled() -> Bool {
        (title.isEmpty || content.isEmpty)
    }

    var body: some View {
        Form(content: {
            Section(header: Text("種類"), content: {
                Picker("種類", selection: $selection, content: {
                    ForEach(TagType.allCases, content: { formType in
                        Text(formType.rawValue)
                            .tag(formType)
                    })
                })
            })
            Section(header: Text("内容"), content: {
                TextField("タイトル", text: $title, isEditing: $isEditing)
                TextEditor(text: $content)
            })
            Button(action: {
                Task {
                    await session.request(title: title, type: selection, content: content)
                    dismiss()
                }
            }, label: {
                Text("送信")
            })
            .disabled(disabled())
        })
        .navigationBarTitleDisplayMode(.inline)
        .navigationTitle("フォーム")
    }
}

struct NotionForm_Previews: PreviewProvider {
    static var previews: some View {
        NotionForm()
    }
}
