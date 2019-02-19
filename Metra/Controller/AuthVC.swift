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
    
    // Outlets
    @IBOutlet weak var signInButton: GIDSignInButton!
    
    // Variables
    let loginManager = FBSDKLoginManager()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //Google
        GIDSignIn.sharedInstance()?.clientID = FirebaseApp.app()?.options.clientID
        GIDSignIn.sharedInstance()?.delegate = self
        GIDSignIn.sharedInstance()?.uiDelegate = self
    
        //Facebook
  
      
    }
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
     //        if Auth.auth().currentUser != nil {
//            dismiss(animated: true, completion: nil)
//        }
}
    
    //Facebook
    @IBAction func signInWithFacebookBtnPressed(_ sender: Any) {
     loginManager.logIn(withReadPermissions: ["email"], from: self) { (result, error) in
            if let error = error {
                debugPrint("Couldn't log to facebook")
            } else if result!.isCancelled {
                print("Login was Cancelled")
            } else {
                let credential = FacebookAuthProvider.credential(withAccessToken: FBSDKAccessToken.current().tokenString)
                self.firebaseLogin(credential)
                let arVC = self.storyboard?.instantiateViewController(withIdentifier: AR_VC) as? RestaurantVC
                self.present(arVC!, animated: true, completion: nil)
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
            let arVC = self.storyboard?.instantiateViewController(withIdentifier: AR_VC) as? RestaurantVC
            self.present(arVC!, animated: true, completion: nil)
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
