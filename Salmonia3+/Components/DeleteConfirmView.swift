//
//  DeleteConfirmView.swift
//  Salmonia3+
//
//  Created by devonly on 2022/09/19.
//

import SwiftUI
import SplatNet3

struct DeleteConfirmView: View {
    @State private var isPresented: Bool = false
    @AppStorage("IS_FIRST_LAUNCH") var isFirstLaunch: Bool = false

    var body: some View {
        ScrollView(content: {
            LazyVGrid(columns: Array(repeating: .init(.flexible(minimum: 40), spacing: nil, alignment: .center), count: 2), content: {
                NSOButton(action: {
                    isFirstLaunch.toggle()
                }, title: {
                    Text(localizedText: "TITLE_ACCOUNT")
                }, icon: {
                    Image("Tabs/Ika1", bundle: .main)
                })
                NSOButton(action: {
                    RealmService.shared.deleteAll()
                }, title: {
                    Text(localizedText: "TITLE_RESULTS")
                }, icon: {
                    Image("Tabs/Salmon", bundle: .main)
                })
            })
        })
    }
}

private struct NSOButton<Title: View>: View {
    @State private var isPresented: Bool = false
    let action: () -> Void
    let title: () -> Title
    let icon: () -> Image

    init(action: @escaping () -> Void, @ViewBuilder title: @escaping () -> Title, @ViewBuilder icon: @escaping () -> Image) {
        self.title = title
        self.icon = icon
        self.action = action
    }

    var body: some View {
        Button(action: {
            isPresented.toggle()
        }, label: {
            VStack(content: {
                Color.blue
                    .frame(width: 84, height: 84, alignment: .center)
                    .clipShape(NSOCircle())
                    .overlay(icon().resizable().scaledToFit().padding(4))
                title()
                    .lineLimit(1)
                    .font(systemName: .Splatfont, size: 16)
                    .frame(height: 16)
            })
        })
        .buttonStyle(.plain)
        .alert(Text(localizedText: "TITLE_CONFIRM_DANGER"), isPresented: $isPresented) {
            Button(role: .destructive, action: {
                action()
            }, label: {
                Text(localizedText: "TITLE_DANGER_OK")
            })
        } message: {
            Text(localizedText: "DESC_DANGER_ERASE")
        }
    }
}

struct DeleteConfirmView_Previews: PreviewProvider {
    static var previews: some View {
        DeleteConfirmView()
            .previewLayout(.fixed(width: 400, height: 400))
    }
}
