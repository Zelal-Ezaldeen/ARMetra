//
//  AuthVC.swift
//  Metra
//
//  Created by Zelal-Ezaldeen on 1/7/19.
//  Copyright © 2019 Metra Company. All rights reserved.
//

import UIKit
import Firebase

class AuthVC: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

      
    }
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        if Auth.auth().currentUser != nil {
            dismiss(animated: true, completion: nil)
        }
    }
    @IBAction func signInWithFacebookBtnPressed(_ sender: Any) {
    }
    @IBAction func signInWithGoogleBtnPressed(_ sender: Any) {
    }
    @IBAction func signInByEmailBtnPressed(_ sender: Any) {
        let loginVC = storyboard?.instantiateViewController(withIdentifier: REGISTER_BY_EMAIL)
        present(loginVC!, animated: true, completion: nil)
    }
    
    @IBAction func signInBtnPressed(_ sender: Any) {
        let loginVC = storyboard?.instantiateViewController(withIdentifier: LOGIN_VC)
        present(loginVC!, animated: true, completion: nil)
    }
}
