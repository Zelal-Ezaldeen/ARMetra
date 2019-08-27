//
//  DesignCommentsVC.swift
//  Metra
//
//  Created by Zelal-Ezaldeen on 8/26/19.
//  Copyright © 2019 Metra Company. All rights reserved.
//

import UIKit
import Firebase


class DesignCommentsVC: UIViewController, UITextViewDelegate, UITableViewDelegate, UITableViewDataSource, CommentDelegate {

   
    //Outlets
    @IBOutlet weak var addCommentTxt: UITextField!
    @IBOutlet weak var keyboardView: UIView!

    @IBOutlet weak var tableView: UITableView!
    //    //Variables
    var design: Design!
    var comments = [Comment]()
    var designRef: DocumentReference!
    let firestore = Firestore.firestore()
    var username: String!
    var designImage: String!
    var commentListner : ListenerRegistration!
    private var handle: AuthStateDidChangeListenerHandle?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.delegate = self
        tableView.dataSource = self
        designRef = firestore.collection(DESIGNS_REF).document(design.documentId)
        if let name = Auth.auth().currentUser?.displayName {
            username = name
        }
        self.view.bindToKeyboard()
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(backGroundTapped))
        view.addGestureRecognizer(tapGesture)
        
    }
    @objc func backGroundTapped() {
        view.endEditing(true)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        commentListner = firestore.collection(DESIGNS_REF).document(self.design.documentId).collection(COMMENTS_REF).addSnapshotListener({ (snapshot, error) in
            
            guard let snapshot = snapshot else {
                debugPrint("Error fetching comments: \(error)")
                print("Yes error in commentDesign")
                return
            }
            print("No error in designCommentVC")
            self.comments.removeAll()
            self.comments = Comment.parseData(snapshot: snapshot)
            self.tableView.reloadData()
        })
    }
    override func viewDidDisappear(_ animated: Bool) {
        if commentListner != nil {
            commentListner.remove()
        }
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return comments.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if let cell = tableView.dequeueReusableCell(withIdentifier: DESIGN_COMMENT_CELL, for: indexPath) as? DesignCommentsCell
        {
            let comment = comments[indexPath.row]
            cell.configureCell(comment: comment, delegate: self)
            return cell
            
        }
        return UITableViewCell()
    }
    
    
    @IBAction func addDesignCommentBtnPressed(_ sender: Any) {
        guard let commentTxt = addCommentTxt.text else { return }
        
        firestore.runTransaction({ (transaction, errorPointer) -> Any? in
            let designDocument: DocumentSnapshot
            do {
                try designDocument = transaction.getDocument(Firestore.firestore().collection(DESIGNS_REF).document(self.design.documentId))
            } catch let error as NSError {
                debugPrint("Error in fetching: \(error.localizedDescription)")
                return nil
            }
            
            guard let oldNumComments = designDocument.data()![NUM_COMMENTS] as? Int else { return nil }
            transaction.updateData([NUM_COMMENTS : oldNumComments + 1], forDocument: self.designRef)
            let newCommentRef = self.firestore.collection(DESIGNS_REF).document(self.design.documentId).collection(COMMENTS_REF).document()
            transaction.setData([
                COMMENT_TXT : commentTxt,
                TIMESTAMP: FieldValue.serverTimestamp(),
                USERNAME: self.username,
                USER_ID: Auth.auth().currentUser?.uid ?? ""
                ],
                                forDocument: newCommentRef)
            return nil
        }) { (object, error) in
            if let error = error {
                debugPrint("Transaction failed: \(error)")
            } else {
                self.addCommentTxt.text = ""
                self.addCommentTxt.resignFirstResponder()
            }
        }
    }
    
    
    func textViewDidBeginEditing(_ textView: UITextView) {
        textView.text = ""
        textView.textColor = UIColor.darkGray
    }
    
    func commentOptionsTapped(comment: Comment) {
        //Adding alert
        let alert = UIAlertController(title: "تعديل التعليق", message: "يمكنك المسح أو التعديل", preferredStyle: .actionSheet)
        //Create the action
        let deleteAction = UIAlertAction(title: "مسح التعليق", style: .default) { (action) in
            
            self.firestore.runTransaction({ (transaction, errorPointer) -> Any? in
                let designDocument: DocumentSnapshot
                do {
                    try designDocument = transaction.getDocument(Firestore.firestore().collection(DESIGNS_REF).document(self.design.documentId))
                } catch let error as NSError {
                    debugPrint("Error in fetching: \(error.localizedDescription)")
                    return nil
                }
                
                guard let oldNumComments = designDocument.data()![NUM_COMMENTS] as? Int else { return nil }
                transaction.updateData([NUM_COMMENTS : oldNumComments - 1], forDocument: self.designRef)
                let commentRef = self.firestore.collection(DESIGNS_REF).document(self.design.documentId).collection(COMMENTS_REF).document(comment.documentId)
                transaction.deleteDocument(commentRef)
                return nil
            }) { (object, error) in
                if let error = error {
                    debugPrint("Transaction failed: \(error)")
                } else {
                    alert.dismiss(animated: true, completion: nil)
                }
            }
        }
        let editAction = UIAlertAction(title: "تعديل التعليق", style: .default) { (action) in
            //Edit the comment
            self.performSegue(withIdentifier: GO_TO_EDIT_DESIGNCOMMENT, sender: (comment, self.design))
            alert.dismiss(animated: true, completion: nil)
        }
        let cancelAction = UIAlertAction(title: "إلغاء", style: .cancel, handler: nil)
        //Add the Actions to our alert
        alert.addAction(deleteAction)
        alert.addAction(editAction)
        alert.addAction(cancelAction)
        present(alert, animated: true, completion: nil)
    }
    
    //This call before preform for segue
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let destination = segue.destination as? UpdateDesignCommentVC {
            if let commentData = sender as? (comment: Comment, design: Design) {
                destination.commentData = commentData
            }
        }
    }
    
    @IBAction func backBtnPressed(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
    
   
}
