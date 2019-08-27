//
//  UpdateDesignCommentVC.swift
//  Metra
//
//  Created by Zelal-Ezaldeen on 8/27/19.
//  Copyright © 2019 Metra Company. All rights reserved.
//

import UIKit
import Firebase

class UpdateDesignCommentVC: UIViewController {

    //Outlets
    @IBOutlet weak var updateBtn: UIButton!
    @IBOutlet weak var commentTxt: UITextView!
    // Variables
    var commentData : (comment: Comment, design: Design)!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        commentTxt.layer.cornerRadius = 10
        updateBtn.layer.cornerRadius = 10
        commentTxt.text = commentData.comment.commentTxt
    }
    
    @IBAction func updateBtnPressed(_ sender: Any) {
        Firestore.firestore().collection(DESIGNS_REF).document(commentData.design.documentId).collection(COMMENTS_REF).document(commentData.comment.documentId).updateData([COMMENT_TXT : commentTxt.text]) { (error) in
            if let error = error {
                debugPrint("Unable to update comment: \(error.localizedDescription)")
            } else {
                self.dismiss(animated: true, completion: nil)
            }
        }
    }
    
    @IBAction func backBtnPressed(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
    
}
