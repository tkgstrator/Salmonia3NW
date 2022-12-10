//
//  MyPageView.swift
//  Salmonia3+
//  
//  Created by devonly on 2022/11/27
//  Copyright © 2022 Magi Corporation. All rights reserved.
//

import SwiftUI
import SplatNet3

struct MyPageView: View {
    var body: some View {
        GeometryReader(content: { geometry in
            let width: CGFloat = (geometry.frame(in: .local).width - 32.0)
            ScrollView(content: {
                LazyVStack(content: {
                    TabView(content: {
                        Color.pink
                            .tag(0)
                        Color.blue
                            .tag(1)
                        Color.yellow
                            .tag(2)
                        Color.red
                            .tag(3)
                    })
                    .tabViewStyle(.page)
                    .aspectRatio(390/195, contentMode: .fit)
                    .padding(.bottom, 35)
                    LazyVGrid(columns: Array(repeating: .init(.flexible()), count: 3), content: {
                        let scale: CGFloat = (1.0 - (3 - 1) * 0.07) / 3.0
                        SignInButton(contentId: .SP3)
                            .frame(width: width * scale)
                        SignInButton(contentId: .SP2)
                            .frame(width: width * scale)
                        SignInButton(contentId: .SP3)
                            .frame(width: width * scale)
                    })
                    .padding(.horizontal)
                })
                LazyVGrid(columns: Array(repeating: .init(.flexible(), alignment: .top), count: 4), content: {
                    let scale: CGFloat = (1.0 - (4 - 1) * 0.07) / 4.0
                    ScheduleButton()
                        .frame(width: width * scale)
                    InAppBrowser.WebView(contentId: .SP2)
                        .frame(width: width * scale)
                    InAppBrowser.WebView(contentId: .SP3)
                        .frame(width: width * scale)
                    SettingButton()
                        .frame(width: width * scale)
                })
                .padding(.horizontal)
            })
        })
        .navigationBarTitleDisplayMode(.inline)
        .navigationTitle(Text(bundle: .Common_MyPage))
    }
}

struct MyPageView_Previews: PreviewProvider {
    static var previews: some View {
        MyPageView()
    }
}
