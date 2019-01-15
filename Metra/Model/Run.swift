//
//  Run.swift
//  Metra
//
//  Created by Zelal-Ezaldeen on 1/15/19.
//  Copyright © 2019 Metra Company. All rights reserved.
//

import Foundation
import RealmSwift

class Run: Object {
    @objc dynamic public private(set) var id = ""
    @objc dynamic public private(set) var date = NSDate()
    @objc dynamic public private(set) var pace = 0
    @objc dynamic public private(set) var distance = 0.0
    @objc dynamic public private(set) var duration = 0

    override class func primaryKey() -> String {
        return "id"
    }
    override class func indexedProperties() -> [String] {
        return ["pace", "date", "duration"]
    }
    
    convenience init(pace: Int, distance: Double, duration: Int) {
        self.init()
        self.id = UUID().uuidString.lowercased()
        self.date = NSDate()
        self.pace = pace
        self.distance = distance
        self.duration = duration
    }
    static func addRunToRealm(pace: Int, distance: Double, duration: Int) {
        REALM_QUEUE.sync {
            let run = Run(pace: pace, distance: distance, duration: duration)
            do {
                let realm = try Realm()
                try realm.write {
                    realm.add(run)
                    try realm.commitWrite()
                }
            } catch {
                debugPrint("Error adding run to realm!")
            }
        }
    }
    
    static func getAllRuns() -> Results<Run>? {
        do {
            let realm = try Realm()
            var runs = realm.objects(Run.self)
            runs = runs.sorted(byKeyPath: "date", ascending: false)
            return runs
        } catch {
            return nil
        }
    }
}
