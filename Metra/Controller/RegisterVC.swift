//
//  RegisterVC.swift
//  restaurantArdyia
//
//  Created by Zelal-Ezaldeen on 12/30/18.
//  Copyright © 2018 Metra Company. All rights reserved.
//

import UIKit
import Firebase
import FirebaseAuth

class RegisterVC: UIViewController, UITextFieldDelegate {

    //Outlets
    @IBOutlet var heightConstarint: NSLayoutConstraint!
    @IBOutlet weak var emaiTxt: UITextField!
    @IBOutlet weak var passwordTxt: UITextField!
    
    @IBOutlet weak var usernameTxt: UITextField!
    @IBOutlet weak var errorLbl: UILabel!
    
    @IBOutlet weak var errorView: ErrorView!
    @IBOutlet weak var spinner: UIActivityIndicatorView!
    override func viewDidLoad() {
      
        super.viewDidLoad()
        emaiTxt.delegate = self
        passwordTxt.delegate = self
        spinner.isHidden = true
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(backGroundTapped))
        view.addGestureRecognizer(tapGesture)
    }
    
    @objc func backGroundTapped() {
        view.endEditing(true)
    }
   
    @IBAction func registerBtnPressed(_ sender: Any) {
        guard let email = emaiTxt.text,
              let password = passwordTxt.text,
              let username = usernameTxt.text else { return }
              spinner.isHidden = false
              spinner.startAnimating()
        //Set up a new user on our Firebase database
        Auth.auth().createUser(withEmail: email, password: password) { (user, error) in
            if error != nil {
                print(error!)
                self.errorLbl.text = "\(String(describing: error?.localizedDescription))"
                self.errorView.isHidden = false
            } else {
                let changeRequest = user?.user.createProfileChangeRequest()
                changeRequest?.displayName = username
                changeRequest?.commitChanges(completion: { (error) in
                    if let error = error {
                        debugPrint(error.localizedDescription)
                    }
                })
                //Store these info for the username in the Database
                guard let userId = user?.user.uid else { return }
               Firestore.firestore().collection(USERS_REF).document(userId).setData([
                    USERNAME : username,
                    DATE_CREATED : FieldValue.serverTimestamp()
                    ], completion:  { (error) in
                        if let error = error {
                            debugPrint(error.localizedDescription)
                        } else {
                            self.spinner.isHidden = true
                            self.spinner.stopAnimating()
                            self.performSegue(withIdentifier: GO_TO_LOGINVC, sender: self)
                        }
                })
            }
        }
    }
    
    @IBAction func closeBtnPressed(_ sender: Any) {
    dismiss(animated: true, completion: nil)
    }
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        self.view.endEditing(true)
        return true
    }
}
