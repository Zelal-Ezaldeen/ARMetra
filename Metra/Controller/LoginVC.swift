//
//  LoginVC.swift
//  restaurantArdyia
//
//  Created by Zelal-Ezaldeen on 12/30/18.
//  Copyright © 2018 Metra Company. All rights reserved.
//

import UIKit
import Firebase

class LoginVC: UIViewController, UITextFieldDelegate {

    //Outlets
   // @IBOutlet var heightConstarint: NSLayoutConstraint!
    @IBOutlet weak var emailTxt: UITextField!
    @IBOutlet weak var passwordTxt: UITextField!
    @IBOutlet weak var spinner: UIActivityIndicatorView!
    @IBOutlet weak var viewError: UIView!
    @IBOutlet weak var errorLbl: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        emailTxt.delegate = self
        passwordTxt.delegate = self
        spinner.isHidden = true
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(backGroundTapped))
        view.addGestureRecognizer(tapGesture)
    }
    
    @objc func backGroundTapped() {
        view.endEditing(true)
    }
   
    @IBAction func logInBtnPressed(_ sender: Any) {
        spinner.isHidden = false
        spinner.startAnimating()
        //Log in the user
        Auth.auth().signIn(withEmail: emailTxt.text!, password: passwordTxt.text!) { (user, error) in
            if error != nil {
                self.errorLbl.text = "\(String(describing: error?.localizedDescription))"
                self.viewError.isHidden = false
            } else {
                self.spinner.isHidden = true
                self.spinner.stopAnimating()
             self.performSegue(withIdentifier: GO_TO_CATEGORYVC, sender: self)
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
