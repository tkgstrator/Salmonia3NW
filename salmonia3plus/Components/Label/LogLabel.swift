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
        Text(bundle: .Custom_Size_Log)
            .badge(Text(SwiftyLogger.sizeOfFile()))
    }
}

struct LogLabel_Previews: PreviewProvider {
    static var previews: some View {
        LogLabel()
    }
}
