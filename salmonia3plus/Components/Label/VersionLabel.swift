//
//  Version.swift
//  Salmonia3+
//  
//  Created by devonly on 2022/12/09
//  Copyright © 2022 Magi Corporation. All rights reserved.
//

import SwiftUI
import SplatNet3

struct VersionLabel: View {
    let version: String = (Bundle.main.object(forInfoDictionaryKey: "CFBundleShortVersionString") as? String) ?? "1.0.0"
    let build: String = (Bundle.main.object(forInfoDictionaryKey: "CFBundleVersion") as? String) ?? "0"

    var body: some View {
        HStack(content: {
            Text(bundle: .Custom_Version)
            Spacer()
            Text(String(format: "%@(%@)", version, build))
                .foregroundColor(.secondary)
        })
    }
}

struct VersionLabel_Previews: PreviewProvider {
    static var previews: some View {
        VersionLabel()
    }
}
