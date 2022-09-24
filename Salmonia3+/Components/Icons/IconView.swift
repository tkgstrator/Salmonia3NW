//
//  IconView.swift
//  Salmonia3+
//
//  Created by devonly on 2022/09/18.
//

import SwiftUI
import SplatNet3

struct NSOLikeButtonStyle: ButtonStyle {
    let foregroundColor: Color

    init(foregroundColor: Color = SPColor.Theme.SPPink) {
        self.foregroundColor = foregroundColor
    }

    func makeBody(configuration: Configuration) -> some View {
        ZStack(alignment: .leading, content: {
            foregroundColor
            configuration.label
                .padding(8)
        })
        .clipShape(RoundedRectangle(cornerRadius: 20))
        .opacity(configuration.isPressed ? 0.8 : 1.0)
    }
}

extension ButtonStyle where Self == NSOLikeButtonStyle {
    /// ニンテンドースイッチオンライン風のボタンを表示します
    internal static var nso: NSOLikeButtonStyle { NSOLikeButtonStyle() }
}

struct NSOCircleActionModifier: ViewModifier {
    let action: () -> Void
    let localizedText: String
    let generator: UINotificationFeedbackGenerator = UINotificationFeedbackGenerator()

    init(localizedText: String, action: @escaping () -> Void) {
        self.action = action
        self.localizedText = localizedText.sha256Hash
    }

    func body(content: Content) -> some View {
        Button(action: {
            generator.notificationOccurred(.success)
            action()
        }, label: {
            VStack(spacing: nil, content: {
                NSOCircle()
                    .scaledToFit()
                    .foregroundColor(SPColor.Theme.SPOrange)
                    .overlay(content.padding(4))
                Text(localizedText)
                    .font(systemName: .Splatfont, size: 16)
                    .frame(height: 16)
                    .foregroundColor(.primary)
            })
        })
        .frame(maxWidth: 100)
    }
}

struct NSOCircleNavigationLinkModifier<T: View>: ViewModifier {
    @State private var isPresented: Bool = false

    let destination: () -> T
    let localizedText: String
    let generator: UINotificationFeedbackGenerator = UINotificationFeedbackGenerator()

    init(localizedText: String, destination: @escaping () -> T) {
        self.destination = destination
        self.localizedText = localizedText.sha256Hash
    }

    func body(content: Content) -> some View {
        NavigationLink(isActive: $isPresented, destination: {
            destination()
        }, label: {
            Button(action: {
                generator.notificationOccurred(.success)
                isPresented.toggle()
            }, label: {
                VStack(spacing: nil, content: {
                    NSOCircle()
                        .scaledToFit()
                        .foregroundColor(SPColor.Theme.SPOrange)
                        .overlay(content.padding(4))
                    Text(localizedText)
                        .font(systemName: .Splatfont, size: 16)
                        .frame(height: 16)
                        .foregroundColor(.primary)
                })
            })
        })
        .frame(maxWidth: 100)
    }
}

extension View {
    func navigationCircleButton<T: View>(localizedText: String, destination: @escaping () -> T) -> some View {
        self.modifier(NSOCircleNavigationLinkModifier(localizedText: localizedText, destination: destination))
    }

    func actionCircleButton(localizedText: String, action: @escaping () -> Void) -> some View {
        self.modifier(NSOCircleActionModifier(localizedText: localizedText, action: action))
    }
}

struct IconView_Previews: PreviewProvider {
    static var previews: some View {
        UserView()
            .previewLayout(.fixed(width: 400, height: 300))
            .preferredColorScheme(.dark)
        UserView()
            .previewLayout(.fixed(width: 400, height: 300))
    }
}
