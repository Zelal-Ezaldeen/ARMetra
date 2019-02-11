//
//  ProductCell.swift
//  Metra
//
//  Created by Zelal-Ezaldeen on 2/11/19.
//  Copyright © 2019 Metra Company. All rights reserved.
//

import UIKit

class ProductCell: UICollectionViewCell {
    @IBOutlet weak var productImage: UIImageView!
    @IBOutlet weak var productTitle: UILabel!
    
    func updateViews(product: Product) {
        productImage.image = UIImage(named: product.imageName)
        productTitle.text = product.title
        
    }
}
