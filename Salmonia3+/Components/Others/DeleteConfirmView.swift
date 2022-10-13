//
//  DeleteConfirmView.swift
//  Salmonia3+
//
//  Created by devonly on 2022/09/19.
//

import SwiftUI
import SplatNet3

struct DeleteConfirmView: View {
    @StateObject var session: Session = Session()
    @State private var isPresented: Bool = false

    var body: some View {
        ScrollView(content: {
            LazyVGrid(columns: Array(repeating: .init(.flexible(minimum: 40), spacing: nil, alignment: .center), count: 2), content: {
                IconList.Accounts()
                IconList.Results()
            })
        })
        .navigationTitle(Text(localizedText: "TITLE_ERASE"))
        .navigationBarTitleDisplayMode(.inline)
    }
}

struct DeleteConfirmView_Previews: PreviewProvider {
    static var previews: some View {
        DeleteConfirmView()
            .previewLayout(.fixed(width: 400, height: 400))
    }
}
