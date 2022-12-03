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

@main
struct mainApp: SwiftUI.App {
    @UIApplicationDelegateAdaptor(AppDelegate.self) var appDelegate
    @StateObject var session: Session = Session()
    private let configuration: Realm.Configuration = Realm.Configuration(
        schemaVersion: 7,
        migrationBlock: RealmMigration.migrationBlock(),
        deleteRealmIfMigrationNeeded: false
    )

    var body: some Scene {
        WindowGroup {
            NavigationView(content: {
                ContentView()
                    .environment(\.realmConfiguration, configuration)
                    .environmentObject(session)
            })
        }
    }

    class AppDelegate: NSObject, UIApplicationDelegate {
        func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]? = nil) -> Bool {
            print(NSSearchPathForDirectoriesInDomains(FileManager.SearchPathDirectory.documentDirectory, FileManager.SearchPathDomainMask.userDomainMask, true)[0])

            return true
        }
    }
}
