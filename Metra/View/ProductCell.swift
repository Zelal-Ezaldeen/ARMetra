//
//  ProductCell.swift
//  Metra
//
//  Created by Zelal-Ezaldeen on 7/13/19.
//  Copyright © 2019 Metra Company. All rights reserved.
//

import UIKit
import Firebase
import FirebaseAuth

class ProductCell: UITableViewCell {

//Outlets
    @IBOutlet weak var productImage: UIImageView!
    @IBOutlet weak var timeStamp: UILabel!
    @IBOutlet weak var usernameLbl: UILabel!
    @IBOutlet weak var commentTxtLbl: UILabel!
    @IBOutlet weak var numCommentsLbl: UILabel!
    @IBOutlet weak var numLikesLbl: UILabel!
    @IBOutlet weak var likesImg: UIImageView!

//Varibles
     private var product: Product!
     private var products = [Product]()
    
    override func awakeFromNib() {
        super.awakeFromNib()
        let tap = UITapGestureRecognizer(target: self, action: #selector(likeTapped))
            likesImg.addGestureRecognizer(tap)
            likesImg.isUserInteractionEnabled = true
   
    }
  
    @objc func likeTapped() {
        
    Firestore.firestore().collection(Products_REF).document(product.documentId)
                .setData([NUM_LIKES : product.numLikes + 1], merge: true)
            }
  
    func updateViews(product: Product) {
        self.product = product
        productImage.image = UIImage(named: product.productImage)
        usernameLbl.text = product.username
        commentTxtLbl.text = product.commentTxt
        numCommentsLbl.text = String(product.numComments)
        numLikesLbl.text = String(product.numLikes)
      
        let formatter = DateFormatter()
        formatter.dateFormat = "d / MM, hh:mm"
        let timestamp = formatter.string(from: product.timeStamp)
        timeStamp.text = timestamp
        
    }
    
    
    
   
}
