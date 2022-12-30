//
//  UploadButton.swift
//  Salmonia3+
//  
//  Created by devonly on 2022/12/31
//  Copyright © 2022 Magi Corporation. All rights reserved.
//

import SwiftUI
import SplatNet3

struct UploadButton: View {
    @EnvironmentObject var session: Session

    var body: some View {
        Button(action: {
            Task(priority: .background, operation: {
                let results: [CoopResult] = try await RealmService.shared.exportData()
                let hosting: UIHostingController = UIHostingController(rootView: CoopResultUploadView(session: session, results: results))
                UIApplication.shared.presentedViewController?.present(hosting, animated: true)
            })
        }, label: {
            Text("アップロード")
        })
    }
}

struct UploadButton_Previews: PreviewProvider {
    static var previews: some View {
        UploadButton()
    }
}
