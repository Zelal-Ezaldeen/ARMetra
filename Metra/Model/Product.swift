//
//  Product.swift
//  Metra
//
//  Created by Zelal-Ezaldeen on 2/11/19.
//  Copyright © 2019 Metra Company. All rights reserved.
//

import Foundation
import Firebase

class Product {
  
    private(set) public var commentTxt: String!
    private(set) public var numLikes: Int!
    private(set) public var numComments: Int!
    private(set) public var documentId: String!
    private(set) public var timeStamp: Date!
    private(set) public var username: String!
    private(set) public var productImage: String!
    private(set) public var userId: String!
    
    init(username: String, commentTxt: String, numLikes: Int, numComments: Int,  timeStamp: Date, productImage: String, documentId: String, userId: String) {
        self.commentTxt = commentTxt
        self.numLikes = numLikes
        self.numComments = numComments
        self.documentId = documentId
        self.username = username
        self.timeStamp = timeStamp
        self.productImage = productImage
        self.userId = userId
      
    }
    
    //Fetching Data from Firebase
    class func parseData(snapshot: QuerySnapshot?) -> [Product] {
        var products = [Product]()
        guard let snap = snapshot else { return products }
        for document in snap.documents {
        let data = document.data()
        let username = data[USERNAME] as? String ?? "Anonymous"
        let timestamp = data[TIMESTAMP] as? Date ?? Date()
        let commentTxt = data[COMMENT_TXT] as? String ?? ""
        let numLikes = data[NUM_LIKES] as? Int ?? 0
        let numComments = data[NUM_COMMENTS] as? Int ?? 0
        let documentId = document.documentID
        let productImage = data[PRODUCT_IMG] as? String ?? ""
        let userId = data[USER_ID] as? String ?? ""
        
        
        let newProduct = Product(username: username, commentTxt: commentTxt, numLikes: numLikes, numComments: numComments, timeStamp: timestamp, productImage: productImage, documentId: documentId, userId: userId)
        products.append(newProduct)
    }
    return products
    }
   
}
