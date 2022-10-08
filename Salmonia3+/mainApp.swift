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

    var body: some Scene {
        WindowGroup {
            ContentView()
                .preferredColorScheme(preferredColorScheme ? .dark : .light)
        }
    }
}

class AppDelegate: NSObject, UIApplicationDelegate {
    private enum Mode: String, CaseIterable, PersistableEnum {
        case REGULAR = "RULE_REGULAR"
        case PRIVATE = "RULE_PRIVATE"
    }

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]? = nil) -> Bool {
        /// Firebase
        FirebaseApp.configure()

        let schemeVersion: UInt64 = 4
        #if DEBUG
        let config = Realm.Configuration(
            schemaVersion: schemeVersion,
            migrationBlock: { migration, oldSchemeVersion in
                if oldSchemeVersion < schemeVersion {
                    // プレイヤー情報を仮アップデート
                    migration.enumerateObjects(ofType: RealmCoopPlayer.className(), { oldValue, newValue in
                        // 超適当なマイグレーションいろんな人に怒られますよ、これ
                        if let newValue: DynamicObject = newValue, let oldValue: DynamicObject = oldValue {
                            if let byname: String = oldValue["byname"] as? String,
                               let nameId: String = oldValue["nameId"] as? String,
                               let isMyself: Bool = oldValue["isMyself"] as? Bool {
                                print("No Migration")
                            } else {
                                newValue["isMyself"] = false
                                newValue["byname"] =
                                newValue["nameId"] = ""
                            }
                        }
                    })
                    // スケジュール情報をアップデート
                    migration.enumerateObjects(ofType: RealmCoopSchedule.className(), { oldValue, newValue in
                        if let newValue: DynamicObject = newValue, let oldValue: DynamicObject = oldValue {
                            // 超適当なマイグレーションいろんな人に怒られますよ、これ
                            if let rawValue: String = oldValue["rule"] as? String,
                               let mode: Mode = Mode(rawValue: rawValue) {
                                newValue["rule"] = Common.Rule.REGULAR
                                newValue["mode"] = mode == .REGULAR ? Common.Mode.REGULAR : Common.Mode.PRIVATE_CUSTOM
                                print(rawValue, mode)
                            }
                            newValue["startTime"] = nil
                            newValue["endTime"] = nil
                            newValue["rareWeapon"] = nil
                        }
                    })
                    // リザルト情報をアップデート
                    migration.enumerateObjects(ofType: RealmCoopResult.className(), { oldValue, newValue in
                        // 超適当なマイグレーションいろんな人に怒られますよ、これ
                        if let newValue: DynamicObject = newValue, let oldValue: DynamicObject = oldValue {
                            // クリア情報を更新(WAVE3をクリアしていたらクリアとする)
                            if let waves: RealmSwift.List<MigrationObject> = oldValue["waves"] as? RealmSwift.List<MigrationObject>,
                               let boolValue: Bool = oldValue["isClear"] as? Bool {
                                // WAVE数が4または既にクリア済みだった
                                newValue["isClear"] = waves.count == 4 || boolValue
                            }

                            // リザルトの先頭は常に自分とする
                            if let players: RealmSwift.List<MigrationObject> = newValue["players"] as? RealmSwift.List<MigrationObject>,
                               let player: MigrationObject = players.first {
                                player["isMyself"] = true
                            }
                        }
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
                    // プレイヤー情報を仮アップデート
                    migration.enumerateObjects(ofType: RealmCoopPlayer.className(), { oldValue, newValue in
                        // 超適当なマイグレーションいろんな人に怒られますよ、これ
                        newValue!["isMyself"] = false
                        newValue!["byname"] = ""
                        newValue!["nameId"] = ""
                    })
                    // スケジュール情報をアップデート
                    migration.enumerateObjects(ofType: RealmCoopSchedule.className(), { oldValue, newValue in
                        // 超適当なマイグレーションいろんな人に怒られますよ、これ
                        newValue!["startTime"] = nil
                        newValue!["endTime"] = nil
                        newValue!["rareWeapon"] = nil
                    })
                    // リザルト情報をアップデート
                    migration.enumerateObjects(ofType: RealmCoopResult.className(), { oldValue, newValue in
                        // 超適当なマイグレーションいろんな人に怒られますよ、これ
                        if let newValue: DynamicObject = newValue, let oldValue: DynamicObject = oldValue {
                            // クリア情報を更新(WAVE3をクリアしていたらクリアとする)
                            if let waves: RealmSwift.List<MigrationObject> = oldValue["waves"] as? RealmSwift.List<MigrationObject>,
                               let boolValue: Bool = oldValue["isClear"] as? Bool {
                                // WAVE数が4または既にクリア済みだった
                                newValue["isClear"] = waves.count == 4 || boolValue
                            }

                            // リザルトの先頭は常に自分とする
                            if let players: RealmSwift.List<MigrationObject> = newValue["players"] as? RealmSwift.List<MigrationObject>,
                               let player: MigrationObject = players.first {
                                player["isMyself"] = true
                            }
                        }
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
            let _ = try! Realm(configuration: config)
        }

        print(NSSearchPathForDirectoriesInDomains(FileManager.SearchPathDirectory.documentDirectory, FileManager.SearchPathDomainMask.userDomainMask, true)[0])

        return true
    }
}
