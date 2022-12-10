//
//  CreditLink.swift
//  Salmonia3+
//  
//  Created by devonly on 2022/12/10
//  Copyright © 2022 Magi Corporation. All rights reserved.
//

import SwiftUI
import SplatNet3

struct CreditLink: View {
    var body: some View {
        NavigationLink(destination: {
            CreditView()
        }, label: {
            Text(bundle: .Settings_Credits)
        })
    }
}

struct CreditLink_Previews: PreviewProvider {
    static var previews: some View {
        CreditLink()
    }
}
