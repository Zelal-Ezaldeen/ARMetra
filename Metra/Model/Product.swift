//
//  Product.swift
//  Metra
//
//  Created by Zelal-Ezaldeen on 2/11/19.
//  Copyright © 2019 Metra Company. All rights reserved.
//

import Foundation

struct Product {
    private(set) public var title: String
    private(set) public var imageName: String
    
    init(title: String, imageName: String) {
        self.title = title
        self.imageName = imageName
    }
}
