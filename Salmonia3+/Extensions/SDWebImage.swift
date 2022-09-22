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
    case SPLATNET3
}

struct SDWebImagePreview: View {
    var body: some View {
        LazyVGrid(columns: Array(repeating: .init(.flexible(minimum: 40, maximum: 80)), count: 3), content: {
            WebImage(loading: .SPLATNET1)
            WebImage(loading: .SPLATNET2)
            WebImage(loading: .SPLATNET3)
        })
    }
}

extension WebImage {
    init(loading: LoadingType) {
        let url: URL? = Bundle.main.url(forResource: loading.rawValue, withExtension: "png")
        self.init(url: url)
    }
}

struct SDWebImage_Previews: PreviewProvider {
    static var previews: some View {
        WebImage(loading: .SPLATNET1)
            .resizable()
            .scaledToFit()
            .background(SPColor.Theme.SPOrange)
            .previewLayout(.fixed(width: 300, height: 300))
        WebImage(loading: .SPLATNET2)
            .resizable()
            .scaledToFit()
            .background(SPColor.Theme.SPOrange)
            .previewLayout(.fixed(width: 300, height: 300))
        WebImage(loading: .SPLATNET3)
            .resizable()
            .scaledToFit()
            .background(SPColor.Theme.SPOrange)
            .previewLayout(.fixed(width: 300, height: 300))
    }
}
