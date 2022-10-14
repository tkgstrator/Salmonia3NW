//
//  SDWebImage.swift
//  Salmonia3+
//
//  Created by devonly on 2022/09/22.
//

import Foundation
import SDWebImageSwiftUI
import SwiftUI
import SplatNet3

enum LoadingType: String, CaseIterable {
    case SPLATNET1
    case SPLATNET2
}

extension WebImage {
    init(loading: LoadingType) {
        let url: URL? = Bundle.main.url(forResource: loading.rawValue, withExtension: "png")
        self.init(url: url)
    }
}
