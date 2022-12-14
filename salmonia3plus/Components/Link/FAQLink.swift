//
//  FAQButton.swift
//  Salmonia3+
//  
//  Created by devonly on 2022/12/09
//  Copyright © 2022 Magi Corporation. All rights reserved.
//

import SwiftUI
import SplatNet3

struct FAQLink: View {
    var body: some View {
        Link(destination: URL(unsafeString: "https://salmonia3.netlify.app/faq"), label: {
            ListRow(title: .Custom_FAQ)
        })
    }
}

struct FAQLink_Previews: PreviewProvider {
    static var previews: some View {
        FAQLink()
    }
}
