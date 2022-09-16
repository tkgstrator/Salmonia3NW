//
//  WeaponsView.swift
//  salmonia3nw
//
//  Created by devonly on 2022/08/25.
//

import SwiftUI
import SplatNet3

struct WeaponsView: View {
    var body: some View {
        NavigationView(content: {
            
        })
        ScrollView(content: {
            LazyVGrid(columns: Array(repeating: .init(.flexible(minimum: 40, maximum: 80)), count: 10), content: {
                ForEach(WeaponType.allCases, id: \.self) { weapon in
                    Image(weaponType: weapon)
                        .resizable()
                        .scaledToFit()
                }
            })
        })
    }
}

extension Image {
    init(weaponType: WeaponType) {
        let rawValue: Int = weaponType.id ?? 0

        self.init("WeaponType/\(rawValue)", bundle: .main)
    }
}

struct WeaponsView_Previews: PreviewProvider {
    static var previews: some View {
        WeaponsView()
    }
}
