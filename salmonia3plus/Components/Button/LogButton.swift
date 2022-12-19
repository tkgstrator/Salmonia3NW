//
//  LogButton.swift
//  Salmonia3+
//  
//  Created by devonly on 2022/12/07
//  Copyright © 2022 Magi Corporation. All rights reserved.
//

import SwiftUI
import Alamofire
import SplatNet3

struct LogButton: View {
    @EnvironmentObject var session: Session
    @State private var isPresented: Bool = false

    var body: some View {
        Button(action: {
            isPresented.toggle()
        }, label: {
            Text(bundle: .Custom_Log)
        })
        .confirmationDialog(
            Text(bundle: .Custom_Log_Txt),
            isPresented: $isPresented,
            titleVisibility: .visible,
            actions: {
                Button(action: {
                    Task {
                        do {
                            let data: Data = try Data(contentsOf: SwiftyLogger.baseURL.absoluteURL, options: .uncached)
                            try await session.upload(data: data)
                        } catch(let error) {
                            SwiftyLogger.error(error.localizedDescription)
                        }
                    }
                }, label: {
                    Text(bundle: .Common_Decide)
                })
            }, message: {
                Text(bundle: .Custom_Log_Txt)
            })

    }
}

struct LogButton_Previews: PreviewProvider {
    static var previews: some View {
        InAppBrowser.WebView(contentId: .SP3)
    }
}
