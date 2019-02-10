//
//  RoundedButton.swift
//  restaurantArdyia
//
//  Created by Zelal-Ezaldeen on 1/2/19.
//  Copyright © 2019 Metra Company. All rights reserved.
//

import UIKit

@IBDesignable
class RoundedButton: UIButton {

    @IBInspectable var cornerRadius: CGFloat = 3.0 {
        didSet {
            self.layer.cornerRadius = cornerRadius
        }
    }
    override func awakeFromNib() {
        
        self.setupView()
    }
    func setupView() {
        self.layer.cornerRadius = cornerRadius
        layer.borderColor = UIColor.white.cgColor
        layer.borderWidth = 3.0
    }

}
