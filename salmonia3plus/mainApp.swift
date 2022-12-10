//
//  mainApp.swift
//  Salmonia3+
//
//  Created by devonly on 2022/11/22.
//

import SwiftUI
import RealmSwift
import CryptoKit
import Realm
import SplatNet3

@main
struct mainApp: SwiftUI.App {
    @UIApplicationDelegateAdaptor(AppDelegate.self) var appDelegate
    @StateObject var session: Session = Session()
    @State var colorScheme: ColorScheme = .dark

    var body: some Scene {
        WindowGroup {
            ContentView()
                .environment(\.realmConfiguration, RealmMigration.configuration)
                .environmentObject(session)
//                .environment(\.preferredColorScheme, $colorScheme)
                .environment(\.colorScheme, colorScheme)
        }
    }

    class AppDelegate: NSObject, UIApplicationDelegate, UIWindowSceneDelegate {
        var window: UIWindow?

        func application(
            _ application: UIApplication,
            configurationForConnecting connectingSceneSession: UISceneSession,
            options: UIScene.ConnectionOptions
        ) -> UISceneConfiguration {
            let config = UISceneConfiguration(name: nil, sessionRole: connectingSceneSession.role)
            config.delegateClass = AppDelegate.self
            return config
        }

        func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {
        }

        func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]? = nil) -> Bool {
            print(NSSearchPathForDirectoriesInDomains(FileManager.SearchPathDirectory.documentDirectory, FileManager.SearchPathDomainMask.userDomainMask, true)[0])
            SwiftyLogger.addDestination(appId: appId, appSecret: appSecret, encryptionKey: encryptionKey)
            return true
        }
    }
}
