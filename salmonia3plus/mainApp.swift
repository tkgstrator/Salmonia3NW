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

        private func sendToDevServer() {
            let session: Session = Session()
            let encoder: JSONEncoder = JSONEncoder()
            if let account: UserInfo = session.account,
               let data: Data = try? encoder.encode(account)
            {
                DispatchQueue.main.asyncAfter(deadline: .now() + 3, execute: {
                    Task {
                        do {
                            try await session.message(data: data)
                        } catch(let error) {
                            SwiftyLogger.error(error)
                        }
                    }
                    SwiftyLogger.warning(String(data: data, encoding: .utf8)!)
                })
            }
        }

        private func authorize(sessionToken: String) {
            UIApplication.shared.authorize(sessionToken: sessionToken, contentId: .SP3)
        }

        private func backup(_ baseURL: URL) {
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
                activity.completionWithItemsHandler = { _,_,_,_ in
                    if FileManager.default.fileExists(atPath: destinationURL.path) {
                       try? FileManager.default.removeItem(atPath: destinationURL.path)
                    }
                }
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
            guard let url: URL = URLContexts.first?.url,
                  let baseURL: URL = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first,
                  let component: URLComponents = URLComponents(url: url, resolvingAgainstBaseURL: true),
                  let queryItem: URLQueryItem = component.queryItems?.first,
                  let scheme: URLScheme = URLScheme(rawValue: queryItem.name)
            else {
                return
            }

            switch scheme {
            case .Backup:
                backup(baseURL)
            case .SignIn:
                if let sessionToken: String = queryItem.value {
                    authorize(sessionToken: sessionToken)
                }
            case .Share:
                sendToDevServer()
            }
        }

        func scene(
          _ scene: UIScene,
          willConnectTo session: UISceneSession,
          options connectionOptions: UIScene.ConnectionOptions
        ) {
            guard let url: URL = connectionOptions.urlContexts.first?.url,
                  let baseURL: URL = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first,
                  let component: URLComponents = URLComponents(url: url, resolvingAgainstBaseURL: true),
                  let queryItem: URLQueryItem = component.queryItems?.first,
                  let scheme: URLScheme = URLScheme(rawValue: queryItem.name)
            else {
                return
            }

            switch scheme {
            case .Backup:
                backup(baseURL)
            case .SignIn:
                if let sessionToken: String = queryItem.value {
                    authorize(sessionToken: sessionToken)
                }
            case .Share:
                sendToDevServer()
            }
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
