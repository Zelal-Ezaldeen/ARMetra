//
//  User.swift
//  Metra
//
//  Created by Zelal-Ezaldeen on 2/6/19.
//  Copyright © 2019 Metra Company. All rights reserved.
//

import Foundation
import RealmSwift

class User: Object {
    @objc dynamic var name: String = ""
    let scenes = List<Scene>()
}
