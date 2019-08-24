//
//  Comment.swift
//  Metra
//
//  Created by Zelal-Ezaldeen on 7/5/19.
//  Copyright © 2019 Metra Company. All rights reserved.
//

import Foundation
import Firebase

class Comment {
    private(set) public var commentTxt: String!
    private(set) public var timeStamp: Date!
    private(set) public var username: String!
    private(set) public var documentId: String!
    private(set) public var userId: String!
  
   
    init(username: String, commentTxt: String, timeStamp: Date, documentId: String, userId: String) {
        self.commentTxt = commentTxt
        self.username = username
        self.timeStamp = timeStamp
        self.documentId = documentId
        self.userId = userId
    }
    
class func parseData(snapshot: QuerySnapshot?) -> [Comment] {
        var comments = [Comment]()
        guard let snap = snapshot else { return comments }
        for document in snap.documents {
            let data = document.data()
            let username = data[USERNAME] as? String ?? "Anonymous"
            let timestamp = data[TIMESTAMP] as? Date ?? Date()
            let commentTxt = data[COMMENT_TXT] as? String ?? ""
            let documentId = document.documentID
            let userId = data[USER_ID] as? String ?? ""
           
         let newComment = Comment(username: username, commentTxt: commentTxt, timeStamp: timestamp, documentId: documentId, userId: userId)
            comments.append(newComment)
}
     return comments

  }
}
