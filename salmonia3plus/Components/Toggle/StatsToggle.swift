//
//  StatsToggle.swift
//  Salmonia3+
//  
//  Created by devonly on 2022/12/21
//  Copyright © 2022 Magi Corporation. All rights reserved.
//

import SwiftUI

struct StatsToggle: View {
    @AppStorage(SceneKey.isResultUploadable.rawValue) var isResultUploadable = false

    var body: some View {
        Toggle(isOn: $isResultUploadable, label: {
            Text("Salmon Stats")
        })
    }
}

struct StatsToggle_Previews: PreviewProvider {
    static var previews: some View {
        StatsToggle()
    }
}
