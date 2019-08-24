//
//  CategoryCell.swift
//  Metra
//
//  Created by Zelal-Ezaldeen on 2/10/19.
//  Copyright © 2019 Metra Company. All rights reserved.
//

import UIKit

class CategoryCell: UITableViewCell {

    @IBOutlet weak var categoryImage: UIImageView!
    @IBOutlet weak var categoryTitle: UILabel!
    
    func updateViews(category: Category) {
        categoryImage.image = UIImage(named: category.imageName)
        categoryTitle.text = category.title
    }

 

}
