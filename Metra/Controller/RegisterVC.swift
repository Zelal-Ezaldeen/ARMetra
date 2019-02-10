//
//  RegisterVC.swift
//  restaurantArdyia
//
//  Created by Zelal-Ezaldeen on 12/30/18.
//  Copyright © 2018 Metra Company. All rights reserved.
//

import UIKit
import Firebase

class RegisterVC: UIViewController, UITextFieldDelegate {

    //Outlets
    @IBOutlet var heightConstarint: NSLayoutConstraint!
    @IBOutlet weak var emaiTxt: UITextField!
    @IBOutlet weak var passwordTxt: UITextField!
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
        spinner.isHidden = false
        spinner.startAnimating()
        //Set up a new user on our Firebase database
        Auth.auth().createUser(withEmail: emaiTxt.text!, password: passwordTxt.text!) { (user, error) in
            if error != nil {
                print(error!)
                self.errorLbl.text = "\(String(describing: error?.localizedDescription))"
                self.errorView.isHidden = false
            } else {
               self.spinner.isHidden = true
                self.spinner.stopAnimating()
                self.performSegue(withIdentifier: GO_TO_ARKIT, sender: self)
            }
            
        }
    }
    
    @IBAction func closeBtnPressed(_ sender: Any) {
     //   performSegue(withIdentifier: TO_WELCOMEVC, sender: nil)
      dismiss(animated: true, completion: nil)
    }
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        self.view.endEditing(true)
        return true
    }
}
