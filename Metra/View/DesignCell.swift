//
//  DesignCell.swift
//  Metra
//
//  Created by Zelal-Ezaldeen on 8/26/19.
//  Copyright © 2019 Metra Company. All rights reserved.
//

import UIKit
import Firebase
import FirebaseAuth

class DesignCell: UITableViewCell {
    
    //Outlets
    @IBOutlet weak var numCommentsLbl: UILabel!
    @IBOutlet weak var designImage: UIImageView!
    @IBOutlet weak var numLikesLbl: UILabel!
    @IBOutlet weak var likesImg: UIImageView!
    @IBOutlet weak var commentTxtLbl: UILabel!
    @IBOutlet weak var usernameLbl: UILabel!
    @IBOutlet weak var timestamp: UILabel!
    //Varibles
    private var design: Design!
    private var designs = [Design]()
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        let tap = UITapGestureRecognizer(target: self, action: #selector(likeTapped))
        likesImg.addGestureRecognizer(tap)
        likesImg.isUserInteractionEnabled = true
        
    }
    
    @objc func likeTapped() {
        Firestore.firestore().collection(DESIGNS_REF).document(design.documentId)
            .setData([NUM_LIKES : design.numLikes + 1], merge: true)
    }
    
    func updateViews(design: Design) {
        self.design = design
        designImage.image = UIImage(named: design.designImage)
        usernameLbl.text = design.username
        commentTxtLbl.text = design.commentTxt
        numCommentsLbl.text = String(design.numComments)
        numLikesLbl.text = String(design.numLikes)
        
        let formatter = DateFormatter()
        formatter.dateFormat = "d / MM, hh:mm"
        let timestamp = formatter.string(from: design.timeStamp)
        self.timestamp.text = timestamp
        
    }
    
    
    
    
}
