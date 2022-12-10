//
//  LanguageButton.swift
//  Salmonia3+
//  
//  Created by devonly on 2022/12/09
//  Copyright © 2022 Magi Corporation. All rights reserved.
//

import SwiftUI
import SplatNet3

struct LanguageButton: View {
    var body: some View {
        Button(action: {
            UIApplication.shared.open(URL(string: UIApplication.openSettingsURLString)!)
        }, label: {
            ListRow(title: .MyOutfits_Reverse)
        })
    }
}

struct LanguageButton_Previews: PreviewProvider {
    static var previews: some View {
        LanguageButton()
    }
}
