//
//  SPButtonStyle.swift
//  Salmonia3+
//  
//  Created by devonly on 2022/11/27
//  Copyright © 2022 Magi Corporation. All rights reserved.
//

import Foundation
import SwiftUI
import SplatNet3

struct SPButtonStyle: ButtonStyle {
    let title: Text
    let color: Color

    init(title: String?, color: Color = SPColor.SplatNet3.SPRed) {
        self.title = Text(String(format: "%@", title))
        self.color = color
    }

    init(title: LocalizedType = .Custom_MyPage, color: Color = SPColor.SplatNet3.SPRed) {
        self.title = Text(bundle: title)
        self.color = color
    }

    func makeBody(configuration: Configuration) -> some View {
        VStack(content: {
            Image(icon: .Circle)
                .renderingMode(.template)
                .resizable()
                .scaledToFit()
                .foregroundColor(color)
                .overlay(content: {
                    configuration
                        .label
                        .padding()
                })
            title
                .font(systemName: .Splatfont2, size: 11)
                .lineLimit(1)
                .multilineTextAlignment(.center)
        })
    }
}

struct SPWebButtonStyle: ButtonStyle {
    let title: Text
    let color: Color

    init(title: String? = nil, color: Color = SPColor.SplatNet3.SPRed) {
        self.title = Text(String(format: "%@", title))
        self.color = color
    }

    init(title: LocalizedType = .Custom_MyPage, color: Color = SPColor.SplatNet3.SPRed) {
        self.title = Text(bundle: title)
        self.color = color
    }

    func makeBody(configuration: Configuration) -> some View {
        VStack(content: {
            configuration
                .label
                .mask(alignment: .center, {
                    Image(icon: .Circle)
                        .resizable()
                        .scaledToFit()
                })
            title
                .font(systemName: .Splatfont2, size: 11)
        })
    }
}

struct SPButtonStyle_Previews: PreviewProvider {
    static var previews: some View {
        GeometryReader(content: { geometry in
            let width: CGFloat = geometry.frame(in: .local).width
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
                        Button(action: {
                        }, label: {
                            Text("ボタン")
                        })
                        .frame(width: width * scale)
                        Button(action: {
                        }, label: {
                            Text("ボタン")
                        })
                        .frame(width: width * scale)
                        Button(action: {
                        }, label: {
                            Text("ボタン")
                        })
                        .frame(width: width * scale)
                    })
                })
                LazyVGrid(columns: Array(repeating: .init(.flexible()), count: 4), content: {
                    let scale: CGFloat = (1.0 - (4 - 1) * 0.07) / 4.0
                    Button(action: {
                    }, label: {
                        Text("ボタン")
                    })
                    .foregroundColor(SPColor.SplatNet3.SPPink)
                    .frame(width: width * scale)
                    Button(action: {
                    }, label: {
                        Text("ボタン")
                    })
                    .foregroundColor(SPColor.SplatNet3.SPBlue)
                    .frame(width: width * scale)
                    Button(action: {
                    }, label: {
                        Text("ボタン")
                    })
                    .foregroundColor(SPColor.SplatNet3.SPSalmonGreen)
                    .frame(width: width * scale)
                    Button(action: {
                    }, label: {
                        Text("ボタン")
                    })
                    .foregroundColor(SPColor.SplatNet3.SPSalmonGreen)
                    .frame(width: width * scale)
                })
            })
        })
        .padding(.horizontal)
    }
}
