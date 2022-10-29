//
//  mainApp.swift
//  Salmonia3+
//
//  Created by devonly on 2022/08/25.
//

import SwiftUI
import RealmSwift
import SplatNet3
import Firebase

@main
struct mainApp: SwiftUI.App {
    @UIApplicationDelegateAdaptor(AppDelegate.self) var appDelegate
    @AppStorage("CONFIG_COLOR_SCHEME") var preferredColorScheme: Bool = true
    /// Realmの設定
    private let configuration: Realm.Configuration = Realm.Configuration(schemaVersion: 5, deleteRealmIfMigrationNeeded: false)

    var body: some Scene {
        WindowGroup {
            ContentView()
                .preferredColorScheme(preferredColorScheme ? .dark : .light)
                .environment(\.realmConfiguration, configuration)
        }
    }
}

class AppDelegate: NSObject, UIApplicationDelegate {
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]? = nil) -> Bool {
        /// Firebaseの初期化
        FirebaseApp.configure()
        /// バージョンチェック
        VersionUpdater.executeVersionCheck()
        print(NSSearchPathForDirectoriesInDomains(FileManager.SearchPathDirectory.documentDirectory, FileManager.SearchPathDomainMask.userDomainMask, true)[0])

        return true
    }
}
