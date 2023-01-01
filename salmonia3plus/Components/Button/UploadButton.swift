//
//  UploadButton.swift
//  Salmonia3+
//  
//  Created by devonly on 2022/12/31
//  Copyright © 2022 Magi Corporation. All rights reserved.
//

import SwiftUI
import SplatNet3
import RealmSwift

struct UploadButton: View {
    @EnvironmentObject var session: Session

    var body: some View {
        Button(action: {
            Task(operation: {
                let results: RealmSwift.Results<RealmCoopResult> = try await RealmService.shared.exportData()
//                print(results.count)
                //                let hosting: UIHostingController = UIHostingController(rootView: CoopResultUploadView(session: session, results: results))
//                UIApplication.shared.presentedViewController?.present(hosting, animated: true)
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
