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
    @AppStorage("PREFERRED_COLOR_SCHEME") var preferredColorScheme: Bool = true

    var body: some Scene {
        WindowGroup {
            ContentView()
                .preferredColorScheme(preferredColorScheme ? .dark : .light)
        }
    }
}

class AppDelegate: NSObject, UIApplicationDelegate {
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]? = nil) -> Bool {
        let schemeVersion: UInt64 = 0
        let config = Realm.Configuration(
            schemaVersion: schemeVersion,
            deleteRealmIfMigrationNeeded: true
            )
        Realm.Configuration.defaultConfiguration = config
        do {
            let _ =  try Realm()
        } catch (let error) {
            print(error)
            let _ = try! Realm(configuration: config)
        }

        print(NSSearchPathForDirectoriesInDomains(FileManager.SearchPathDirectory.documentDirectory, FileManager.SearchPathDomainMask.userDomainMask, true)[0])

        return true
    }
}
