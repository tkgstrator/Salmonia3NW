//
//  SwiftUI+Image.swift
//  Salmonia3+
//
//  Created by devonly on 2022/09/28.
//

import Foundation
import SwiftUI

enum BackgroundType: String, CaseIterable, Codable {
    case SPLATNET2 = "SplatNet2"
    case SPLATNET3 = "SplatNet3"
}

enum ResultType: Int, CaseIterable, Codable {
    case FAILURE
    case CLEAR
}

enum MaskType: Int, CaseIterable, Codable {
    case WAVE
    case BACKGROUND
    case WAVE_BACKGROUND
}

enum ButtonType: String, CaseIterable, Codable {
    case Arrows
    case BackArrow
    case Chart
    case Circle
    case Flag
    case GesoTown
    case GoldenIkura
    case Ikura
    case Salmon
    case Solo
    case Squid
    case Team
    case Update
    case Weapon
    case LineChart
    case Eye
    case EyeSlash
    case Defeated
    case Wear
    case Review
    case Home
    case User
    case Privacy
    case Rescue
    case Death
    case Wave
    case Hanger
    case Card
}

extension Image {
    init(bundle: BackgroundType) {
        self.init("BackgroundType/\(bundle.rawValue)", bundle: .main)
    }

    init(bundle: ButtonType) {
        self.init("ButtonType/\(bundle.rawValue)", bundle: .main)
    }

    init(bundle: ResultType) {
        self.init("ResultType/\(bundle.rawValue)", bundle: .main)
    }

    init(bundle: MaskType) {
        self.init("MaskType/\(bundle.rawValue)", bundle: .main)
    }
}

struct ResultType_Previews: PreviewProvider {
    @Environment(\.locale) var locale

    static var previews: some View {
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
    }
}

