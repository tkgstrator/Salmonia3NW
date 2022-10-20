//
//  TutorialView.swift
//  Salmonia3+
//
//  Created by devonly on 2022/09/18.
//

import SwiftUI
import Introspect
import AppTrackingTransparency
import SplatNet3
import SDWebImageSwiftUI

struct TutorialView: View {
    @State private var selection: Int = 0
    
    var body: some View {
        TabView(selection: $selection, content: {
            Tutorial(
                selection: $selection,
                title: NSLocalizedString("TITLE_APPLICATION", comment: ""),
                description: NSLocalizedString("DESC_APPLICATION", comment: "")
            )
            .tag(0)
            Tutorial(
                selection: $selection,
                title: NSLocalizedString("TITLE_TRACKING", comment: ""),
                description: NSLocalizedString("DESC_TRACKING_USAGE_DATA", comment: "")
            )
            .trackingiOS()
            .transition(.fade)
            .tag(1)
            TutorialSignIn()
                .tag(2)
        })
        .tabViewStyle(.page(indexDisplayMode: .always))
        .background(SPColor.Theme.SPOrange.ignoresSafeArea())
    }
}


private struct TutorialSignIn: View {
    @AppStorage("CONFIG_IS_FIRST_LAUNCH_V2") var isFirstLaunch: Bool = true
    @StateObject var session: Session = Session()
    @State private var isModalPresented: Bool = false
    @State private var isPresented: Bool = false
    @State private var verifier: String? = nil
    @State private var code: String? = nil

    var body: some View {
        GeometryReader(content: { geometry in
            Text(localizedText: "TITLE_SIGN_IN")
                .fontWeight(.bold)
                .foregroundColor(.white)
                .font(Font.system(size: 24))
                .multilineTextAlignment(.center)
                .position(x: geometry.center.x, y: 100)
            Text(localizedText: "DESC_SIGN_IN")
                .foregroundColor(.white)
                .font(Font.system(size: 14))
                .multilineTextAlignment(.center)
                .frame(width: 300, height: nil, alignment: .center)
                .position(x: geometry.center.x, y: 160)
            WebImage(loading: .SPLATNET1)
                .resizable()
                .scaledToFit()
                .frame(width: 140, alignment: .center)
                .position(geometry.center)
            Button(action: {
                isPresented.toggle()
            }, label: {
                Text(localizedText: "BUTTON_SIGN_IN")
                    .fontWeight(.bold)
                    .frame(width: 300, height: 60, alignment: .center)
                    .foregroundColor(SPColor.Theme.SPOrange)
                    .background(.white)
                    .cornerRadius(30)
            })
            .position(x: geometry.center.x, y: geometry.height - 100)
            .authorize(isPresented: $isPresented, completion: { result in
                switch result {
                case .success((let code, let verifier)):
                    self.code = code
                    self.verifier = verifier
                    isModalPresented.toggle()
                case .failure(let error):
                    print(error)
                }
            })
            .fullScreen(isPresented: $isModalPresented, content: {
                LoadingView(code: $code, verifier: $verifier, onSuccess: {
                    isFirstLaunch.toggle()
                })
            })
        })
    }
}

private struct Tutorial: View {
    @Binding var selection: Int
    let title: String
    let description: String

    init(selection: Binding<Int>, title: String? = nil, description: String? = nil) {
        self._selection = selection
        self.title = title ?? ""
        self.description = description ?? ""
    }

    var body: some View {
        GeometryReader(content: { geometry in
            Text(localizedText: title)
                .fontWeight(.bold)
                .foregroundColor(.white)
                .font(Font.system(size: 26))
                .multilineTextAlignment(.center)
                .position(x: geometry.center.x, y: 100)
            Text(localizedText: description)
                .foregroundColor(.white)
                .font(Font.system(size: 14))
                .position(x: geometry.center.x, y: 160)
                .multilineTextAlignment(.center)
                .frame(width: 300, height: nil, alignment: .center)
            WebImage(loading: .SPLATNET1)
                .resizable()
                .scaledToFit()
                .frame(width: 140, alignment: .center)
                .position(geometry.center)
            Button(action: {
                withAnimation(.easeInOut(duration: 1)) {
                    selection += 1
                }
            }, label: {
                Text(localizedText: "BUTTON_NEXT")
                    .fontWeight(.bold)
                    .frame(width: 300, height: 60, alignment: .center)
                    .foregroundColor(SPColor.Theme.SPOrange)
                    .background(.white)
                    .cornerRadius(30)
            })
            .position(x: geometry.center.x, y: geometry.height - 100)
        })
    }
}

struct TutorialView_Previews: PreviewProvider {
    static var previews: some View {
        TutorialView()
    }
}