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
                description: NSLocalizedString("NSUserTrackingUsageDescription", comment: "")
            )
            .authorize()
            .transition(.fade)
            .tag(1)
            TutorialSignIn()
                .tag(2)
        })
        .tabViewStyle(.page(indexDisplayMode: .always))
        .background(Color(hex: "FF7500"))
    }
}

private struct NSTrackingConfirm: ViewModifier {
    func body(content: Content) -> some View {
        content
            .onAppear(perform: {
                DispatchQueue.main.asyncAfter(deadline: .now() + 1, execute: {
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
            })
    }
}

private extension View {
    func authorize() -> some View {
        self.modifier(NSTrackingConfirm())
    }
}

private struct TutorialSignIn: View {
    @StateObject var session: Session = Session()
    @State private var isPresented: Bool = false
    @AppStorage("IS_FIRST_LAUNCH") var isFirstLaunch: Bool = true

    var body: some View {
        GeometryReader(content: { geometry in
            Text("TITLE_SIGN_IN")
                .fontWeight(.bold)
                .foregroundColor(.white)
                .font(Font.system(size: 24))
                .position(x: geometry.center.x, y: 100)
            Text("DESC_SIGN_IN")
                .foregroundColor(.white)
                .font(Font.system(size: 14))
                .position(x: geometry.center.x, y: 160)
            Button(action: {
                isPresented.toggle()
            }, label: {
                Text("Sign in")
                    .fontWeight(.bold)
                    .frame(width: 300, height: 50, alignment: .center)
                    .foregroundColor(Color(hex: "FF7500"))
                    .background(.white)
                    .cornerRadius(25)
            })
            .position(x: geometry.center.x, y: geometry.height - 100)
            .popup(isPresented: $session.isPopuped, view: {
                LoadingView(session: session)
            })
            .authorize(isPresented: $isPresented, session: session, onDismiss: {
                isFirstLaunch.toggle()
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
            Text(title)
                .fontWeight(.bold)
                .foregroundColor(.white)
                .font(Font.system(size: 24))
                .position(x: geometry.center.x, y: 100)
            Text(description)
                .foregroundColor(.white)
                .font(Font.system(size: 14))
                .position(x: geometry.center.x, y: 160)
            Button(action: {
                withAnimation(.easeInOut(duration: 1)) {
                    selection += 1
                }
            }, label: {
                Text("Next")
                    .fontWeight(.bold)
                    .frame(width: 300, height: 50, alignment: .center)
                    .foregroundColor(Color(hex: "FF7500"))
                    .background(.white)
                    .cornerRadius(25)
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
