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
            UIApplication.shared.startAnimating(completion: {
                do {
                    let results: [CoopResult] = try RealmService.shared.exportData()
                    if results.isEmpty {
                        return
                    }
                    let hosting: UIHostingController = UIHostingController(rootView: CoopResultUploadView(session: session, results: results))
                    hosting.modalPresentationStyle = .overFullScreen
                    hosting.modalTransitionStyle = .crossDissolve
                    hosting.view.backgroundColor = UIColor(red: 0, green: 0, blue: 0, alpha: 0.3)
                    hosting.overrideUserInterfaceStyle = .dark
                    UIApplication.shared.presentedViewController?.present(hosting, animated: true)
                } catch(let error) {
                    SwiftyLogger.error(error)
                    let alert: UIAlertController = UIAlertController(title: LocalizedType.Error_Error.localized, message: error.localizedDescription, preferredStyle: .alert)
                    let action: UIAlertAction = UIAlertAction(title: LocalizedType.Common_Decide.localized, style: .default)
                    alert.addAction(action)
                    UIApplication.shared.presentedViewController?.present(alert, animated: true)
                }
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
