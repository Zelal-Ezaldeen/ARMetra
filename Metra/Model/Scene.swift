//
//  Scene.swift
//  Metra
//
//  Created by Zelal-Ezaldeen on 2/6/19.
//  Copyright © 2019 Metra Company. All rights reserved.
//

import Foundation
import RealmSwift

class Scene: Object {
    @objc dynamic var name: String! = ""
    @objc dynamic var done: Bool = false
    var parentUser = LinkingObjects(fromType: User.self, property: "scenes")
}
