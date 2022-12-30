//
//  CustomActivityViewController.swift
//  Salmonia3+
//  
//  Created by devonly on 2022/12/23
//  Copyright © 2022 Magi Corporation. All rights reserved.
//

import Foundation
import UIKit
import SwiftUI

class CustomActivityViewController: UIActivityViewController {
    init(url: URL, colorScheme: ColorScheme) {
        super.init(activityItems: [url], applicationActivities: nil)
        self.overrideUserInterfaceStyle = colorScheme == .dark ? .dark : .light
    }
}
