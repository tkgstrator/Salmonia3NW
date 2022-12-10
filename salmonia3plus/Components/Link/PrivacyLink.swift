//
//  PrivacyLink.swift
//  Salmonia3+
//  
//  Created by devonly on 2022/12/09
//  Copyright © 2022 Magi Corporation. All rights reserved.
//

import SwiftUI

struct PrivacyLink: View {
    var body: some View {
        Link(destination: URL(unsafeString: "https://salmonia3.netlify.app"), label: {
            ListRow(title: .Common_Privacy_Policy)
        })
    }
}

struct PrivacyLink_Previews: PreviewProvider {
    static var previews: some View {
        PrivacyLink()
    }
}
