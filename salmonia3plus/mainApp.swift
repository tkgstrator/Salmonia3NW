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

    var body: some Scene {
        WindowGroup {
            NavigationView(content: {
                ContentView()
                    .environment(\.realmConfiguration, RealmMigration.configuration)
                    .environmentObject(session)
            })
        }
    }

    class AppDelegate: NSObject, UIApplicationDelegate {
        func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]? = nil) -> Bool {
            print(NSSearchPathForDirectoriesInDomains(FileManager.SearchPathDirectory.documentDirectory, FileManager.SearchPathDomainMask.userDomainMask, true)[0])
            SwiftyLogger.addDestination(appId: appId, appSecret: appSecret, encryptionKey: encryptionKey)
            return true
        }
    }
}
