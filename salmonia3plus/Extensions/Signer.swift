//
//  Signer.swift
//  Salmonia3+
//  
//  Created by devonly on 2023/01/01
//  Copyright © 2023 Magi Corporation. All rights reserved.
//

import Foundation
import SplatNet3
import CryptoKit
import RealmSwift

/// 署名付きリザルト
class SignedRealmCoopResult: Codable {
    let signature: Data
    let schedules: [RealmCoopSchedule]

    init(signature: Data, schedules: RealmSwift.Results<RealmCoopSchedule>) {
        self.signature = signature
        self.schedules = Array(schedules)
    }
}

/// 電子署名をサポートするクラス
class Signer {
    // 指定した値をプライベートキーにするので失敗することはありえない
    private static let privateKey: Curve25519.Signing.PrivateKey = try! Curve25519.Signing.PrivateKey(rawRepresentation: Data(base64Encoded: appSecretKey)!)
    private static let publicKey: Data = privateKey.publicKey.rawRepresentation

    private init() {}

    /// 署名
    class func sign(schedules: RealmSwift.Results<RealmCoopSchedule>) throws -> Data {
        let encoder: SPEncoder = SPEncoder()
        let data: Data = try encoder.encode(schedules)
        let signature: Data = try! privateKey.signature(for: data)
        return try encoder.encode(SignedRealmCoopResult(signature: signature, schedules: schedules))
    }

    /// 改竄チェック
    class func isValid(data: Data) -> Bool {
        let decoder: SPDecoder = SPDecoder()
        let encoder: SPEncoder = SPEncoder()
        guard let signingPublicKey = try? Curve25519.Signing.PublicKey(rawRepresentation: publicKey),
              let signedResult: SignedRealmCoopResult = try? decoder.decode(SignedRealmCoopResult.self, from: data),
              let data: Data = try? encoder.encode(signedResult.schedules)
        else {
            return false
        }
        return signingPublicKey.isValidSignature(signedResult.signature, for: data)
    }
}
