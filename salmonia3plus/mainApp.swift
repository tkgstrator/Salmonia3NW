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
import ZIPFoundation

@main
struct mainApp: SwiftUI.App {
    @UIApplicationDelegateAdaptor(AppDelegate.self) var appDelegate
    @State var colorScheme: ColorScheme = .dark

    var body: some Scene {
        WindowGroup {
            ContentView()
                .environment(\.realmConfiguration, RealmMigration.configuration)
                .environmentObject(Session())
                .environment(\.preferredColorScheme, $colorScheme)
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

        func sendRealmToArchive(_ baseURL: URL) {
            let suffix: String = {
                let formatter: DateFormatter = DateFormatter()
                formatter.dateFormat = "yyyyMMddHHmmss"
                return formatter.string(from: Date())
            }()
            let destinationURL: URL = baseURL.appendingPathComponent("realm\(suffix)", conformingTo: .zip)

            do {
                let sourceURL: URL = baseURL.appendingPathComponent("default").appendingPathExtension("realm")
                try FileManager.default.zipItem(at: sourceURL, to: destinationURL)
                let activity: UIActivityViewController = UIActivityViewController(activityItems: [destinationURL], applicationActivities: nil)
                DispatchQueue.main.asyncAfter(deadline: .now() + 1, execute: {
                    UIApplication.shared.presentedViewController?.popover(activity, animated: true)
                })
                return
            } catch(let error) {
                SwiftyLogger.error(error)
            }
        }

        func scene(
            _ scene: UIScene,
            openURLContexts URLContexts: Set<UIOpenURLContext>
        ) {
            guard let _ = URLContexts.first?.url,
                  let baseURL: URL = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first
            else {
                return
            }

            sendRealmToArchive(baseURL)
        }

        func scene(
          _ scene: UIScene,
          willConnectTo session: UISceneSession,
          options connectionOptions: UIScene.ConnectionOptions
        ) {
            guard let _ = connectionOptions.urlContexts.first?.url,
                  let baseURL: URL = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first
            else {
                return
            }
            sendRealmToArchive(baseURL)
        }

        func application(
            _ application: UIApplication,
            didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]? = nil
        ) -> Bool {
            print(NSSearchPathForDirectoriesInDomains(FileManager.SearchPathDirectory.documentDirectory, FileManager.SearchPathDomainMask.userDomainMask, true)[0])
            SwiftyLogger.configure()
            SwiftyLogger.addDestination(appId: appId, appSecret: appSecret, encryptionKey: encryptionKey)

            return true
        }
    }
}
