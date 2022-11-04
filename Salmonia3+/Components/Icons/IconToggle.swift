//
//  IconToggle.swift
//  Salmonia3+
//
//  Created by tkgstrator on 2022/09/23.
//

import SwiftUI
import SplatNet3

enum NSOToggle {
    struct BackgroundImage: View {
        @AppStorage("CONFIG_BACKGROUND_STYLE") var isPresented: Bool = true

        var body: some View {
            IconToggle(isPresented: $isPresented, configuration: .PLAYER_BACKGROUND)
        }
    }

    struct ColorScheme: View {
        @AppStorage("CONFIG_COLOR_SCHEME") var isPresented: Bool = true

        var body: some View {
            IconToggle(isPresented: $isPresented, configuration: .PREFERRED_SCHEME)
        }
    }

    struct RotaionEffect: View {
        @AppStorage("CONFIG_ROTATION_EFFECT") var isPresented: Bool = true

        var body: some View {
            IconToggle(isPresented: $isPresented, configuration: .ROTATION_EFFECT)
        }
    }
}

enum AppConfiguration: String, CaseIterable, Codable {
    /// プレイヤーの背景
    case PLAYER_BACKGROUND
    /// カラーテーマ
    case PREFERRED_SCHEME
    /// WAVEを回転させるかどうか
    case ROTATION_EFFECT
}

struct IconToggle: View {
    @Binding var isPresented: Bool
    /// 設定項目
    let configuration: String

    init(isPresented: Binding<Bool>, configuration: AppConfiguration) {
        self._isPresented = isPresented
        self.configuration = configuration.rawValue
    }

    var body: some View {
        VStack(alignment: .leading, spacing: nil, content: {
            HStack(content: {
                Text("TITLE_\(configuration)".sha256Hash)
                    .lineLimit(1)
                Spacer()
                Text(isPresented ? "SplatNet2" : "Salmonia3")
                    .underline()
            })
            .font(systemName: .Splatfont, size: 16)
            .foregroundColor(.white)
            Text("DESC_\(configuration)".sha256Hash)
                .lineLimit(1)
                .font(systemName: .Splatfont2, size: 16)
                .foregroundColor(.white)
        })
        .padding(.horizontal, 8)
        .modifier(IconToggleViewModifier(isPresented: $isPresented))
    }
}

struct IconToggleViewModifier: ViewModifier{
    /// ボタンが有効化どうか
    @Binding var isPresented: Bool
    let generator: UINotificationFeedbackGenerator = UINotificationFeedbackGenerator()

    init(isPresented: Binding<Bool>) {
        self._isPresented = isPresented
    }

    func body(content: Content) -> some View {
        Button(action: {
            // ここで設定を切り替えてその値を保存する
            generator.notificationOccurred(.success)
            isPresented.toggle()
            //  ただし、ボタンが有効化どうかはこのボタンが表示されたときに反映されないといけない
        }, label: {
            content
        })
        .buttonStyle(NSOLikeButtonStyle(
            foregroundColor: isPresented ? SPColor.Theme.SPPink : SPColor.Theme.SPOrange
        ))
    }
}

struct IconToggle_Previews: PreviewProvider {
    static var previews: some View {
        ScrollView(content: {
            LazyVGrid(columns: Array(repeating: .init(.flexible()), count: 1), content: {
                NSOToggle.BackgroundImage()
                NSOToggle.ColorScheme()
                NSOToggle.RotaionEffect()
            })
        })
        .previewLayout(.fixed(width: 400, height: 600))
    }
}
