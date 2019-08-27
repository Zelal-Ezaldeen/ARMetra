//
//  DesignsVC.swift
//  Metra
//
//  Created by Zelal-Ezaldeen on 8/25/19.
//  Copyright © 2019 Metra Company. All rights reserved.
//

import UIKit
import Firebase
import FirebaseAuth
import GoogleSignIn
import FBSDKCoreKit
import FBSDKLoginKit
class DesignsVC: UIViewController, UITableViewDataSource, UITableViewDelegate {

    // Outlets
  
    @IBOutlet weak var tableView: UITableView!
    // Variables
    private var designs = [Design]()
    private var category: Category!
    private var designsCollectionRef: CollectionReference!
    private var designsListner: ListenerRegistration!
    private var handle: AuthStateDidChangeListenerHandle?
    let loginManager = LoginManager()
    
    override func viewDidLoad() {
       
        super.viewDidLoad()
        tableView.dataSource = self
        tableView.delegate = self
        designsCollectionRef = Firestore.firestore().collection(DESIGNS_REF)
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
       
        //Fetching Data from Firebase
        self.designsListner = self.designsCollectionRef.addSnapshotListener({ (snapshot, error) in
            if let error = error {
                debugPrint("Error fetching: \(error)")
                  print("YESSSSS error in designVC")
            } else {
                self.designs.removeAll()
                self.designs = Design.parseData(snapshot: snapshot)
                self.tableView.reloadData()
                print("NOOOOO error in design vc")
            }
        })
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        if designsListner != nil {
            designsListner.remove()
        }
    }
    
   
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return designs.count
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if let cell = tableView.dequeueReusableCell(withIdentifier: DESIGN_CELL, for: indexPath) as? DesignCell  {
            let design = designs[indexPath.row]
            cell.updateViews(design: design)
            print("YESSSSS")
            return cell
        }
        print("NOOO")
        return DesignCell()
    }
    //When we select the cell
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        handle = Auth.auth().addStateDidChangeListener({ (auth, user) in
            if user == nil {
                let storyboard = UIStoryboard(name: "Main", bundle: nil)
                let loginVC = storyboard.instantiateViewController(withIdentifier: AUTH_VC)
                self.present(loginVC, animated: true, completion: nil)
                
            } else {
                self.performSegue(withIdentifier: GO_TO_DESIGNCOMMENTSVC, sender: self.designs[indexPath.row])
            }
        })
        
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier ==  GO_TO_DESIGNCOMMENTSVC {
            if let destinationVC = segue.destination as? DesignCommentsVC  {
                if let design = sender as? Design {
                    destinationVC.design = design
                    
                }
            }
        }
    }
    @IBAction func signOutBtnPressed(_ sender: Any) {
        //Log out user and send them back to the WelcomeVC
        let logoutPopup = UIAlertController(title: "تسجيل الخروج؟", message: "هل تريد تسجيل الخروج؟", preferredStyle: .actionSheet)
        
        let logoutAction = UIAlertAction(title: "تسجيل الخروج؟", style: .destructive) { (buttonTapped) in
            do {
                
                try Auth.auth().signOut()
                let authVC = self.storyboard?.instantiateViewController(withIdentifier: CATEGORY_VC) as? CategoryVC
                self.present(authVC!, animated: true, completion: nil)
            } catch {
                print(error)
            }
            
        }
        logoutPopup.addAction(logoutAction)
        
        let logoutActionCancel = UIAlertAction(title: "إلغاء", style: .cancel) { (buttonTapped) in
            
        }
        logoutPopup.addAction(logoutActionCancel)
        
        present(logoutPopup, animated: true, completion: nil)
    }
    
    
    func logoutSocial() {
        guard let user = Auth.auth().currentUser else { return }
        for info in (user.providerData) {
            switch info.providerID {
            case GoogleAuthProviderID:
                GIDSignIn.sharedInstance().signOut()
            case FacebookAuthProviderID:
                loginManager.logOut()
            default:
                break
            }
        }
    }
    
    func textViewDidBeginEditing(_ textView: UITextView) {
        textView.text = ""
        textView.textColor = UIColor.darkGray
    }
    
    @IBAction func backBtnPressed(_ sender: Any) {
          performSegue(withIdentifier: GO_TO_CATEGORYVC, sender: self)
    }
}
