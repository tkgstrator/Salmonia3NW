//
//  UserView.swift
//  salmonia3nw
//
//  Created by tkgstrator on 2022/08/25.
//

import SwiftUI
import SplatNet3
import RealmSwift

struct UserView: View {
    @AppStorage("CONFIG_APP_DEVELOPER_MODE") var isAppDeveloperMode: Bool = false

    var body: some View {
        ScrollView(content: {
            LazyVGrid(columns: Array(repeating: .init(.flexible(minimum: 40)), count: 3), spacing: 16, content: {
                IconList.NSO()
                IconList.Review()
                IconList.Appearance()
                IconList.Setting()
                IconList.Privacy()
                IconList.Schedule()
                IconList.Form()
                if isAppDeveloperMode {
                    IconList.Debug()
                }
#if DEBUG
                IconList.Chart()
#endif
            })
        })
        .navigationBarTitleDisplayMode(.inline)
        .navigationTitle(Text(bundle: .Common_MyPage))
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
