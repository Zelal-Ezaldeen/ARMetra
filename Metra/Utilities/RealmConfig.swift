//
//  RealmConfig.swift
//  Metra
//
//  Created by Zelal-Ezaldeen on 1/15/19.
//  Copyright © 2019 Metra Company. All rights reserved.
//

import Foundation
import RealmSwift

class RealmConfig {
    static var runDataConfig: Realm.Configuration {
        
        //Path to save items
        let realmPath = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)[0].appendingPathComponent(REALM_RUN_CONFIG)
        let config = Realm.Configuration(
            fileURL: realmPath,
            schemaVersion: 0,
            migrationBlock: {migration, oldSchemaVersion in
                if (oldSchemaVersion < 0) {
                    
                }
        })
        return config
    }
}
