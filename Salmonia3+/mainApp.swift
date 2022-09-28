//
//  salmonia3nwApp.swift
//  salmonia3nw
//
//  Created by devonly on 2022/08/25.
//

import SwiftUI
import RealmSwift
import FirebaseCore

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
        let schemeVersion: UInt64 = 3
        #if DEBUG
        let config = Realm.Configuration(
            schemaVersion: schemeVersion,
            migrationBlock: { migration, oldSchemeVersion in
                if oldSchemeVersion < schemeVersion {
                    migration.enumerateObjects(ofType: RealmCoopPlayer.className(), { oldValue, newValue in
                        // 超適当なマイグレーションいろんな人に怒られますよ、これ
                        newValue!["isMyself"] = false
                        newValue!["byname"] = ""
                        newValue!["nameId"] = ""
                    })
                    migration.enumerateObjects(ofType: RealmCoopSchedule.className(), { oldValue, newValue in
                        // 超適当なマイグレーションいろんな人に怒られますよ、これ
                        newValue!["startTime"] = nil
                        newValue!["endTime"] = nil
                        newValue!["rareWeapon"] = nil
                    })
                }
            },
            deleteRealmIfMigrationNeeded: false
            )
        #else
        let config = Realm.Configuration(
            schemaVersion: schemeVersion,
            migrationBlock: { migration, oldSchemeVersion in
                if oldSchemeVersion < schemeVersion {
                    migration.enumerateObjects(ofType: RealmCoopPlayer.className(), { oldValue, newValue in
                        // 超適当なマイグレーションいろんな人に怒られますよ、これ
                        newValue!["isMyself"] = false
                        newValue!["byname"] = ""
                        newValue!["nameId"] = ""
                    })
                    migration.enumerateObjects(ofType: RealmCoopSchedule.className(), { oldValue, newValue in
                        // 超適当なマイグレーションいろんな人に怒られますよ、これ
                        newValue!["startTime"] = nil
                        newValue!["endTime"] = nil
                        newValue!["rareWeapon"] = nil
                    })
                    migration.enumerateObjects(ofType: RealmCoopResult.className(), { oldValue, newValue in
                        // 超適当なマイグレーションいろんな人に怒られますよ、これ
                        // WAVE数が4または既にクリア済みだった
                        newValue!["isClear"] = oldValue!["waves"].count == 4 || oldValue!["isClear"]
                    })
                }
            },
            deleteRealmIfMigrationNeeded: false
            )
        #endif
        Realm.Configuration.defaultConfiguration = config
        do {
            let _ =  try Realm(configuration: config)
        } catch (let error) {
            print(error)
            let _ = try! Realm(configuration: config)
        }

        print(NSSearchPathForDirectoriesInDomains(FileManager.SearchPathDirectory.documentDirectory, FileManager.SearchPathDomainMask.userDomainMask, true)[0])

        return true
    }
}
