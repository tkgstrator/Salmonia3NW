//
//  TutorialView.swift
//  Salmonia3+
//
//  Created by devonly on 2022/09/18.
//

import SwiftUI
import Introspect
import AppTrackingTransparency
import GoogleMobileAds
import SplatNet3
import SDWebImageSwiftUI
import PopupView

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
            .authorize()
            .transition(.fade)
            .tag(1)
            TutorialSignIn()
                .tag(2)
        })
        .tabViewStyle(.page(indexDisplayMode: .always))
        .background(SPColor.Theme.SPOrange.ignoresSafeArea())
    }
}

private struct NSTrackingConfirm: ViewModifier {
    func body(content: Content) -> some View {
        content
            .onAppear(perform: {
                let status = ATTrackingManager.trackingAuthorizationStatus
                switch status {
                case .notDetermined:
                    print("Not determined")
                    ATTrackingManager.requestTrackingAuthorization(completionHandler: { status in
                        switch status {
                        case .notDetermined:
                            break
                        case .restricted:
                            print("Restricted")
                            GADMobileAds.sharedInstance().start(completionHandler: nil)
                        case .denied:
                            print("Denied")
                            GADMobileAds.sharedInstance().start(completionHandler: nil)
                        case .authorized:
                            print("Authorized")
                            GADMobileAds.sharedInstance().start(completionHandler: nil)
                        @unknown default:
                            fatalError()
                        }
                    })
                case .restricted:
                    print("Restricted")
                    GADMobileAds.sharedInstance().start(completionHandler: nil)
                case .denied:
                    print("Denied")
                    GADMobileAds.sharedInstance().start(completionHandler: nil)
                case .authorized:
                    print("Authorized")
                    GADMobileAds.sharedInstance().start(completionHandler: nil)
                @unknown default:
                    fatalError()
                }
            })
    }
}

private extension View {
    func authorize() -> some View {
        self.modifier(NSTrackingConfirm())
    }
}

private struct TutorialSignIn: View {
    @Environment(\.isFirstLaunch) var isFirstLaunch: Binding<Bool>
    @StateObject var session: Session = Session()
    @State private var isPresented: Bool = false
    @State private var isModalPopuped: Bool = false

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
            #if DEBUG
            VStack(content: {
                Button(action: {
                    isFirstLaunch.wrappedValue.toggle()
                }, label: {
                    Text("デバッグの強制エラー対策")
                        .fontWeight(.bold)
                        .frame(width: 300, height: 60, alignment: .center)
                        .foregroundColor(SPColor.Theme.SPOrange)
                        .background(.white)
                        .cornerRadius(30)
                })
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
            })
            .position(x: geometry.center.x, y: geometry.height - 100)
            .authorize(
                isPresented: $isPresented,
                session: session,
                onPresent: {
                    isModalPopuped.toggle()
                },
                onDismiss: {
                    // ログイン終了したらチュートリアルを非表示にする
                    DispatchQueue.main.asyncAfter(deadline: .now() + 1, execute: {
                        isFirstLaunch.wrappedValue.toggle()
                    })
                },
                onFailure: {
                    isModalPopuped.toggle()
                })
            .popup(isPresented: $isModalPopuped, view: {
                LoadingView(session: session)
            })
            #else
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
            .disabled(isModalPopuped)
            .position(x: geometry.center.x, y: geometry.height - 100)
            .authorize(
                isPresented: $isPresented,
                session: session,
                onPresent: {
                    isModalPopuped.toggle()
                },
                onDismiss: {
                    // ログイン終了したらチュートリアルを非表示にする
                    DispatchQueue.main.asyncAfter(deadline: .now() + 1, execute: {
                        isFirstLaunch.wrappedValue.toggle()
                    })
                },
                onFailure: {
                    isModalPopuped.toggle()
                })
            .popup(isPresented: $isModalPopuped, view: {
                LoadingView(session: session)
            })
            #endif
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