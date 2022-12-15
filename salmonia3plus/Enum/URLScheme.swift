//
//  URLScheme.swift
//  Salmonia3+
//  
//  Created by devonly on 2022/12/15
//  Copyright © 2022 Magi Corporation. All rights reserved.
//

import Foundation

enum URLScheme: String, CaseIterable {
    case Backup = "backup_realm"
    case SignIn = "session_token"
    case Share  = "share_account"
}
