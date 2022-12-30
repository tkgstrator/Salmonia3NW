//
//  Version13.swift
//  Salmonia3+
//
//  Created by devonly on 2022/12/24
//  Copyright © 2022 Magi Corporation. All rights reserved.
//

import Foundation
import RealmSwift
import Realm
import CryptoKit

extension RealmMigration {
    /// プライマリーキーを設定する
    static func version13(_ migration: Migration) {
        var resultIds: [String] = []
        migration.enumerateObjects(ofType: RealmCoopResult.className(), { oldValue, newValue in
            if let newValue: DynamicObject = newValue,
               let oldValue: DynamicObject = oldValue
            {
                if let id: String = oldValue["id"] as? String {
                    if let resultId: String = id.base64DecodedString {
                        /// Base64デコードできて既に含まれている場合は削除
                        if resultIds.contains(resultId) {
                            migration.delete(newValue)
                        } else {
                            /// Base64デコードできて既に含まれていない場合はプライマリキーを上書きして追加
                            resultIds.append(resultId)
                            newValue["id"] = resultId
                        }
                    } else {
                        /// Base64デコードきない場合は指定されたフォーマットに従うならそのまま
                        if id.contains("CoopHistoryDetail") {
                            resultIds.append(id)
                        } else {
                            migration.delete(newValue)
                        }
                    }
                }
            }
        })
    }
}
