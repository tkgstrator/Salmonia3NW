//
//  ResultLabel.swift
//  Salmonia3+
//  
//  Created by devonly on 2022/12/09
//  Copyright © 2022 Magi Corporation. All rights reserved.
//

import SwiftUI
import RealmSwift

struct ResultLabel: View {
    @ObservedResults(RealmCoopResult.self) var results

    var body: some View {
        Text(bundle: .Custom_Results_Count)
            .badge(Text(String(format: "%d", results.count)))
    }
}

struct ResultLabel_Previews: PreviewProvider {
    static var previews: some View {
        ResultLabel()
    }
}
