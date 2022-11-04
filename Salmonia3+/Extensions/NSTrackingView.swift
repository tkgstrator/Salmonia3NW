//
//  NSTrackingView.swift
//  Salmonia3+
//
//  Created by tkgstrator on 2022/09/25.
//

import SwiftUI
import GoogleMobileAds
import AppTrackingTransparency

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

extension View {
    func trackingiOS() -> some View {
        self.modifier(NSTrackingConfirm())
    }
}
