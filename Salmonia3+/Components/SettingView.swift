//
//  SettingView.swift
//  Salmonia3+
//
//  Created by devonly on 2022/09/22.
//

import SwiftUI
import SplatNet3

struct SettingView: View {
    @AppStorage("IS_USE_NAMEPLATE") var isUseNamePlate: Bool = false

    var body: some View {
        ScrollView(content: {
            LazyVGrid(columns: Array(repeating: .init(.flexible(minimum: 40)), count: 1), content: {
                Button(action: {
                    isUseNamePlate.toggle()
                }, label: {
                    HStack(alignment: .top, spacing: nil, content: {
                        Image(bundle: BadgeType.Mission_Lv03)
                            .resizable()
                            .scaledToFit()
                            .frame(width: 84, height: 84, alignment: .center)
                        VStack(alignment: .leading, spacing: 0, content: {
                            HStack(content: {
                                Text("プレイヤー背景")
                                    .font(systemName: .Splatfont, size: 20)
                                Spacer()
                                Image(systemName: "arrow.triangle.2.circlepath")
                                    .resizable()
                                    .scaledToFit()
                                    .font(Font.system(size: 30, weight: .bold))
                                    .frame(width: 30, height: 30, alignment: .center)
                                    .padding(4)
                                    .foregroundColor(.white)
                            })
                            Text(isUseNamePlate ? "ネームプレートを使います" : "イカリング2形式を使います")
                                .font(systemName: .Splatfont2, size: 18)
                                .multilineTextAlignment(.leading)
                        })
                        .foregroundColor(.white)
                    })
                })
                .padding(.horizontal, 4)
                .background(RoundedRectangle(cornerRadius: 20).fill(SPColor.Theme.SPPink))
            })
            .padding(.horizontal)
        })
        .navigationTitle(Text(localizedText: "TAB_SETTING"))
        .navigationBarTitleDisplayMode(.inline)
    }
}

struct SettingView_Previews: PreviewProvider {
    static var previews: some View {
        SettingView()
    }
}
