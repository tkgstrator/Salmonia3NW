//
//  LogLabel.swift
//  Salmonia3+
//
//  Created by devonly on 2022/12/09
//  Copyright © 2022 Magi Corporation. All rights reserved.
//

import SwiftUI
import SplatNet3

struct LogLabel: View {
    var body: some View {
        HStack(content: {
            Text(bundle: .Custom_Log)
            Spacer()
            Text(SwiftyLogger.sizeOfFile())
                .foregroundColor(.secondary)
        })
    }
}

struct LogLabel_Previews: PreviewProvider {
    static var previews: some View {
        LogLabel()
    }
}
