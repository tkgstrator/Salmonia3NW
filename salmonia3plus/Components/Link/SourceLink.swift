//
//  SourceButton.swift
//  Salmonia3+
//  
//  Created by devonly on 2022/12/09
//  Copyright © 2022 Magi Corporation. All rights reserved.
//

import SwiftUI
import SplatNet3

struct SourceLink: View {
    var body: some View {
        Link(destination: URL(unsafeString: "https://github.com/tkgstrator/Salmonia3NW"), label: {
            ListRow(title: .Settings_Title)
        })
    }
}

struct SourceLink_Previews: PreviewProvider {
    static var previews: some View {
        SourceLink()
    }
}
