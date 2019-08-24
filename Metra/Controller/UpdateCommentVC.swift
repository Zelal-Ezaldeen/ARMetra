//
//  UpdateCommentVC.swift
//  Metra
//
//  Created by Zelal-Ezaldeen on 8/3/19.
//  Copyright © 2019 Metra Company. All rights reserved.
//

import UIKit
import Firebase

class UpdateCommentVC: UIViewController {
// Outlets
    @IBOutlet weak var commentTxt: UITextView!
    @IBOutlet weak var updateBtn: UIButton!
    // Variables
    var commentData : (comment: Comment, product: Product)!
    override func viewDidLoad() {
        super.viewDidLoad()
        commentTxt.layer.cornerRadius = 10
        updateBtn.layer.cornerRadius = 10
        commentTxt.text = commentData.comment.commentTxt
    }
 
    @IBAction func updateBtnTapped(_ sender: Any) {
        Firestore.firestore().collection(Products_REF).document(commentData.product.documentId).collection(COMMENTS_REF).document(commentData.comment.documentId).updateData([COMMENT_TXT : commentTxt.text]) { (error) in
            if let error = error {
                debugPrint("Unable to update comment: \(error.localizedDescription)")
            } else {
                self.dismiss(animated: true, completion: nil)
            }
        }
     }
    
    @IBAction func backBtn(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
}
