//
//  CommentCell.swift
//  Metra
//
//  Created by Zelal-Ezaldeen on 7/5/19.
//  Copyright © 2019 Metra Company. All rights reserved.
//

import UIKit
import Firebase
import FirebaseAuth

protocol CommentDelegate {
    func commentOptionsTapped(comment: Comment)
}
class CommentCell: UITableViewCell {

    //Outlets
    @IBOutlet weak var commentsTxt: UILabel!
    @IBOutlet weak var usernameLbl: UILabel!
    @IBOutlet weak var timeStampLbl: UILabel!
    @IBOutlet weak var optionsMenu: UIImageView!
    //Variables
    private var comment: Comment!
    private var delegate: CommentDelegate?
    
    
    func configureCell(comment: Comment, delegate: CommentDelegate?) {
        usernameLbl.text = comment.username
        commentsTxt.text = comment.commentTxt
       optionsMenu.isHidden = true
        self.comment = comment
        self.delegate = delegate
        let formatter = DateFormatter()
        formatter.dateFormat = "d / MM, hh:mm"
        let timestamp = formatter.string(from: comment.timeStamp)
        timeStampLbl.text = timestamp
        
        if comment.userId == Auth.auth().currentUser?.uid {
            optionsMenu.isHidden = false
            let tap = UITapGestureRecognizer(target: self, action: #selector(commentOptionsTapped))
            optionsMenu.addGestureRecognizer(tap)
            optionsMenu.isUserInteractionEnabled = true
        }
    }
    
    @objc func commentOptionsTapped() {
        delegate?.commentOptionsTapped(comment: comment)
    }
}
