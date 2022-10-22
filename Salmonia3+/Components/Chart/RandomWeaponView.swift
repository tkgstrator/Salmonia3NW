//
//  RandomWeaponView.swift
//  Salmonia3+
//
//  Created by devonly on 2022/10/22.
//

import SwiftUI

struct RandomWeaponView: View {
    let randoms: [Grizzco.WeaponData]
    let columnSize: Int = UIDevice.current.userInterfaceIdiom == .pad ? 5 : 4

    var body: some View {
        ScrollView(content: {
            LazyVGrid(columns: Array(repeating: .init(.flexible(), alignment: .top), count: columnSize), content: {
                ForEach(randoms.indices, id: \.self) { index in
                    let random: Grizzco.WeaponData = randoms[index]
                    Label(title: {
                        Text(String(format: "x%d", random.count))
                            .font(systemName: .Splatfont2, size: 14)
                    }, icon: {
                        Image(bundle: random.weaponId)
                            .resizable()
                            .scaledToFit()
                            .frame(width: 30, height: 30, alignment: .center)
                    })
                }
            })
        })
        .navigationBarBackButtonHidden()
        .navigationTitle(Text(bundle: .Record_WeaponRecord))
    }
}

//struct RandomWeaponView_Previews: PreviewProvider {
//    static var previews: some View {
//        RandomWeaponView()
//    }
//}
