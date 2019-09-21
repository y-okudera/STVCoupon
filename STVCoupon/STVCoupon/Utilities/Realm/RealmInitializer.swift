//
//  RealmInitializer.swift
//  SharedRealmDemoApp
//
//  Created by Yuki Okudera on 2019/08/17.
//  Copyright © 2019 Yuki Okudera. All rights reserved.
//

import Foundation
import RealmSwift

final class RealmInitializer: RealmInitializerCompatible {
    
    let configuration: Realm.Configuration?
    
    init(configuration: Realm.Configuration? = defaultConfiguration()) {
        self.configuration = configuration
    }
    
    static func defaultConfiguration() -> Realm.Configuration {
        let configuration = Realm.Configuration()
        return configuration
    }
}
