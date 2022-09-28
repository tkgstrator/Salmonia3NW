//
//  SwiftUI+Image.swift
//  Salmonia3+
//
//  Created by devonly on 2022/09/28.
//

import Foundation
import SwiftUI

enum ResultType: Int, CaseIterable, Codable {
    case FAILURE
    case CLEAR
}

extension Image {
    init(bundle: ResultType) {
        self.init("ResultType/\(bundle.rawValue)", bundle: .main)
    }
}

struct ResultType_Previews: PreviewProvider {
    @Environment(\.locale) var locale

    static var previews: some View {
//        ForEach(Locale.availableIdentifiers, id: \.self) { locale in
        LazyVGrid(columns: Array(repeating: .init(.fixed(60)), count: 2), content: {
            Image(bundle: .CLEAR)
                .resizable()
                .scaledToFit()
            Image(bundle: .FAILURE)
                .resizable()
                .scaledToFit()
        })
        .previewLayout(.fixed(width: 200, height: 200))
        .environment(\.locale, .init(identifier: "ja_JP"))
//        }
    }
}

