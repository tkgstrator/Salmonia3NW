//
//  salmonia3nwApp.swift
//  salmonia3nw
//
//  Created by devonly on 2022/08/25.
//

import SwiftUI
import RealmSwift

@main
struct mainApp: SwiftUI.App {
    @UIApplicationDelegateAdaptor(AppDelegate.self) var appDelegate
    @AppStorage("CONFIG_COLOR_SCHEME") var preferredColorScheme: Bool = true
    @AppStorage("CONFIG_IS_FIRST_LAUNCH") var isFirstLaunch: Bool = true
    @AppStorage("CONFIG_IS_IN_OAUTH") var isOAuthPresented: Bool = false

    var body: some Scene {
        WindowGroup {
            ContentView()
                .preferredColorScheme(preferredColorScheme ? .dark : .light)
                .environment(\.isFirstLaunch, $isFirstLaunch)
                .environment(\.isOAuthPresented, $isOAuthPresented)
        }
    }
}

class AppDelegate: NSObject, UIApplicationDelegate {
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]? = nil) -> Bool {
        let schemeVersion: UInt64 = 0
        #if DEBUG
        let config = Realm.Configuration(
            schemaVersion: schemeVersion,
            deleteRealmIfMigrationNeeded: true
            )
        #else
        let config = Realm.Configuration(
            schemaVersion: schemeVersion,
            deleteRealmIfMigrationNeeded: false
            )
        #endif
        Realm.Configuration.defaultConfiguration = config
        do {
            let _ =  try Realm()
        } catch (let error) {
            let _ = try! Realm(configuration: config)
        }

        print(NSSearchPathForDirectoriesInDomains(FileManager.SearchPathDirectory.documentDirectory, FileManager.SearchPathDomainMask.userDomainMask, true)[0])

        return true
    }
}
