//
//  mainApp.swift
//  Salmonia3+
//
//  Created by tkgstrator on 2022/08/25.
//

import SwiftUI
import RealmSwift
import SplatNet3
import Firebase

@main
struct mainApp: SwiftUI.App {
    @UIApplicationDelegateAdaptor(AppDelegate.self) var appDelegate
    /// Realmの設定
    private let configuration: Realm.Configuration = Realm.Configuration(schemaVersion: 5, deleteRealmIfMigrationNeeded: false)
    @StateObject var appearances: Appearance = Appearance()

    var body: some Scene {
        WindowGroup {
            ContentView()
                .environment(\.colorScheme, appearances.colorScheme ? .dark : .light)
                .environment(\.realmConfiguration, configuration)
                .environmentObject(appearances)
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
