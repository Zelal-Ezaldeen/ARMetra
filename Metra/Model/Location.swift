//
//  Location.swift
//  Metra
//
//  Created by Zelal-Ezaldeen on 1/15/19.
//  Copyright © 2019 Metra Company. All rights reserved.
//

import Foundation
import RealmSwift

class Location: Object {
    @objc dynamic public private(set)var latitude = 0.0
    @objc dynamic public private(set)var longitude = 0.0
    
    convenience init(latitude: Double, longitude: Double) {
        self.init()
        self.latitude = latitude
        self.longitude = longitude
    }

}
