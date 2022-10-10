//
//  UserView.swift
//  salmonia3nw
//
//  Created by devonly on 2022/08/25.
//

import SwiftUI
import SplatNet3
import RealmSwift

struct UserView: View {

    var body: some View {
        ScrollView(content: {
            GeometryReader(content: { geometry in
                LazyVGrid(columns: Array(repeating: .init(.flexible(minimum: 40)), count: 3), spacing: 16, content: {
                    IconList.NSO()
                    IconList.Review()
                    IconList.Appearance()
                    IconList.Setting()
                    IconList.Privacy()
                    IconList.Schedule()
                    IconList.Debug()
#if DEBUG
                    IconList.Status()
                    IconList.Chart()
                    IconList.Friends()
#else
#endif
                })
            })
        })
        .navigationTitle(Text(bundle: .Common_Home))
        .navigationBarTitleDisplayMode(.inline)
    }
}

struct UserView_Previews: PreviewProvider {
    static var previews: some View {
        UserView()
            .previewLayout(.fixed(width: 400, height: 300))
        UserView()
            .previewLayout(.fixed(width: 400, height: 300))
            .preferredColorScheme(.dark)
    }
}
