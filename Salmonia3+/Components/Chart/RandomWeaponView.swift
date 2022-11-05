//
//  RandomWeaponView.swift
//  Salmonia3+
//
//  Created by tkgstrator on 2022/10/22.
//

import SwiftUI

struct RandomWeaponView: View {
    let data: [Grizzco.Chart.Weapons.Entry]
    let columnSize: Int = UIDevice.current.userInterfaceIdiom == .pad ? 5 : 4

    init(data: [Grizzco.Chart.Weapons.Entry]) {
        self.data = data.sorted(by: { $0.count < $1.count })
    }

    var body: some View {
        ScrollView(content: {
            LazyVGrid(columns: Array(repeating: .init(.flexible(), alignment: .top), count: columnSize), content: {
                ForEach(data) { entry in
                    Label(title: {
                        Text(String(format: "x%d", entry.count))
                            .font(systemName: .Splatfont2, size: 16)
                    }, icon: {
                        Image(bundle: entry.id)
                            .resizable()
                            .scaledToFit()
                            .frame(width: 34, height: 34)
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
