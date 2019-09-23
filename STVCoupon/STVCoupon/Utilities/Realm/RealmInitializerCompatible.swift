//
//  RealmInitializerCompatible.swift
//  SharedRealmDemoApp
//
//  Created by Yuki Okudera on 2019/08/17.
//  Copyright © 2019 Yuki Okudera. All rights reserved.
//

import Foundation
import RealmSwift

protocol RealmInitializerCompatible {
    var configuration: Realm.Configuration? { get }
    
    static func defaultConfiguration() -> Realm.Configuration
    static func encryptionKey() -> Data?
}

// MARK: - Default implementation
extension RealmInitializerCompatible {
    static func encryptionKey() -> Data? {
        return nil
    }
}
