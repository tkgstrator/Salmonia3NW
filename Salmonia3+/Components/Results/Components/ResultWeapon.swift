//
//  ResultWeapon.swift
//  Salmonia3+
//
//  Created by devonly on 2022/09/17.
//

import SwiftUI
import SplatNet3
import RealmSwift

struct ResultWeapon: View {
    let weaponList: [WeaponType]
    let specialWeapon: SpecialType

    init(weaponList: RealmSwift.List<WeaponType>, specialWeapon: SpecialType) {
        self.weaponList = Array(weaponList)
        self.specialWeapon = specialWeapon
    }

    init(weaponList: [WeaponType], specialWeapon: SpecialType) {
        self.weaponList = weaponList
        self.specialWeapon = specialWeapon
    }

    var body: some View {
        GeometryReader(content: { geometry in
            let scale: CGFloat = geometry.width / 172
            LazyVGrid(columns: Array(repeating: .init(.fixed(28 * scale), spacing: 2), count: max(6, weaponList.count + 3)), alignment: .center, spacing: 0, content: {
                Image(bundle: specialWeapon)
                        .resizable()
                        .scaledToFit()
                        .padding(2 * scale)
                        .background(Circle().fill(Color.black.opacity(0.9)))
                        .hidden()
                ForEach(weaponList.indices, id: \.self) { index in
                    let weapon: WeaponType = weaponList[index]
                    Image(bundle: weapon)
                        .resizable()
                        .scaledToFit()
                        .padding(2 * scale)
                        .background(Circle().fill(Color.black.opacity(0.9)))
                }
                Image(bundle: specialWeapon)
                        .resizable()
                        .scaledToFit()
                        .padding(2 * scale)
                        .background(Circle().fill(Color.black.opacity(0.9)))
                Image(bundle: specialWeapon)
                        .resizable()
                        .scaledToFit()
                        .padding(2 * scale)
                        .background(Circle().fill(Color.black.opacity(0.9)))
                        .hidden()
            })
            .position(geometry.center)
        })
        .aspectRatio(172/40, contentMode: .fit)
    }
}

struct ResultWeapon_Previews: PreviewProvider {
    static var weaponList: [WeaponType] = [.Saber_Normal, .Saber_Normal, .Saber_Normal]
    static var previews: some View {
        ResultWeapon(weaponList: weaponList, specialWeapon: .SpUltraShot)
            .previewLayout(.fixed(width: 200, height: 30))
        ResultWeapon(weaponList: weaponList, specialWeapon: .SpUltraShot)
            .previewLayout(.fixed(width: 400, height: 60))
    }
}
