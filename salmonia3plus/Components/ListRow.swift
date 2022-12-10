//
//  ListRow.swift
//  Salmonia3+
//  
//  Created by devonly on 2022/12/09
//  Copyright © 2022 Magi Corporation. All rights reserved.
//

import SwiftUI
import SplatNet3

struct ListRow: View {
    let title: LocalizedType

    var body: some View {
        HStack(content: {
            Text(bundle: title)
                .foregroundColor(.primary)
            Spacer()
            Image(systemName: "chevron.right")
                .font(.system(size: 14, weight: .semibold))
                .foregroundColor(.secondary)
        })
    }
}

struct ListRow_Previews: PreviewProvider {
    static var previews: some View {
        ListRow(title: .Common_Wipe_Data)
    }
}
