//
//  AuthVC.swift
//  Metra
//
//  Created by Zelal-Ezaldeen on 1/7/19.
//  Copyright © 2019 Metra Company. All rights reserved.
//

import UIKit
import Firebase
import GoogleSignIn
import FBSDKCoreKit
import FBSDKLoginKit

class AuthVC: UIViewController, GIDSignInDelegate, GIDSignInUIDelegate {
    
// Variables
    let loginManager = LoginManager()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
// Google
        GIDSignIn.sharedInstance()?.clientID = FirebaseApp.app()?.options.clientID
        GIDSignIn.sharedInstance()?.delegate = self
        GIDSignIn.sharedInstance()?.uiDelegate = self
      
    }
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
}
    
// Facebook
    @IBAction func signInWithFacebookBtnPressed(_ sender: Any) {
        loginManager.logIn(permissions: ["email"], from: self) { (result, error) in
        if error != nil {
                debugPrint("Couldn't log to facebook")
            } else if result!.isCancelled {
                print("Login was Cancelled")
            } else {
            let credential = FacebookAuthProvider.credential(withAccessToken: AccessToken.current!.tokenString)
                self.firebaseLogin(credential)
          //  self.performSegue(withIdentifier: GO_TO_CATEGORYVC, sender: self)
              let categoryVC = self.storyboard?.instantiateViewController(withIdentifier: CATEGORY_VC) as? CategoryVC
             self.present(categoryVC!, animated: true, completion: nil)
        }
    }
}
    //Google
    @IBAction func signInWithGoogle(_ sender: Any) {
        GIDSignIn.sharedInstance().signIn()
    }
    @IBAction func signInByEmailBtnPressed(_ sender: Any) {
        let loginVC = storyboard?.instantiateViewController(withIdentifier: REGISTER_BY_EMAIL)
        present(loginVC!, animated: true, completion: nil)
    }
    
    @IBAction func signInBtnPressed(_ sender: Any) {
        let loginVC = storyboard?.instantiateViewController(withIdentifier: LOGIN_VC)
        present(loginVC!, animated: true, completion: nil)
    }
    
    @IBAction func closeBtnPressed(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
    
    func sign(_ signIn: GIDSignIn!, didSignInFor user: GIDGoogleUser!, withError error: Error!) {
        if let error = error {
            debugPrint("Could not log in with Google. : \(error)")
        } else {
            guard let controller = GIDSignIn.sharedInstance()?.uiDelegate as? AuthVC else { return }
            guard let authitication = user.authentication else { return }
            let credential = GoogleAuthProvider.credential(withIDToken: authitication.idToken, accessToken: authitication.accessToken)
            controller.firebaseLogin(credential)
           // self.performSegue(withIdentifier: GO_TO_CATEGORYVC, sender: self)
            let categoryVC = self.storyboard?.instantiateViewController(withIdentifier: CATEGORY_VC) as? CategoryVC
            self.present(categoryVC!, animated: true, completion: nil)
        }
    }
  
    func firebaseLogin(_ credential: AuthCredential) {
        Auth.auth().signInAndRetrieveData(with: credential) { (user, error) in
            if let error = error {
                debugPrint(error.localizedDescription)
                return
            }
        }
    }
 
}
