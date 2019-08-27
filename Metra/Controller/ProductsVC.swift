//
//  ProductsVC.swift
//  Metra
//
//  Created by Zelal-Ezaldeen on 2/11/19.
//  Copyright © 2019 Metra Company. All rights reserved.
//

import UIKit
import Firebase
import FirebaseAuth
import GoogleSignIn
import FBSDKCoreKit
import FBSDKLoginKit

class ProductsVC: UIViewController, UITableViewDelegate, UITableViewDataSource, UITextViewDelegate {
    
// Outlets
    @IBOutlet weak var tableView: UITableView!
// Variables
    private var products = [Product]()
    private var category: Category!
    private var commentsCollectionRef: CollectionReference!
    private var commentsListner: ListenerRegistration!
    private var handle: AuthStateDidChangeListenerHandle?
    let loginManager = LoginManager()
   
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.dataSource = self
        tableView.delegate = self
        commentsCollectionRef = Firestore.firestore().collection(Products_REF)
       
    }
  
    override func viewWillAppear(_ animated: Bool) {
     
//Fetching Data from Firebase
                self.commentsListner = self.commentsCollectionRef.addSnapshotListener({ (snapshot, error) in
                               if let error = error {
                                   debugPrint("Error fetching: \(error)")
                                   } else {
                                     self.products.removeAll()
                                     self.products = Product.parseData(snapshot: snapshot)
                                     self.tableView.reloadData()
            }
        })
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        if commentsListner != nil {
             commentsListner.remove()
        }
    }
    
//    func initProducts(category: Category)  {
//        products = DataService.instance.getProducts(forCategoryTitle: category.title)
//        
//
//    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return products.count
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if let cell = tableView.dequeueReusableCell(withIdentifier: PRODUCT_CELL, for: indexPath) as? ProductCell  {
            let product = products[indexPath.row]
            cell.updateViews(product: product)
                       return cell
        }
        return ProductCell()
    }
    //When we select the cell
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        handle = Auth.auth().addStateDidChangeListener({ (auth, user) in
            if user == nil {
                let storyboard = UIStoryboard(name: "Main", bundle: nil)
                let loginVC = storyboard.instantiateViewController(withIdentifier: AUTH_VC)
                self.present(loginVC, animated: true, completion: nil)
                
            } else {
                self.performSegue(withIdentifier: Go_TO_COMMENTSVC, sender: self.products[indexPath.row])
            }
        })
      
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == Go_TO_COMMENTSVC {
            if let destinationVC = segue.destination as? CommentsVC  {
                if let product = sender as? Product {
                      destinationVC.product = product
                   
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
    
    
    //    @IBAction func scaleImage(_ sender: UIPinchGestureRecognizer) {
//
////        bigImage.transform = CGAffineTransform(scaleX: sender.scale, y: sender.scale)
//    }
    func textViewDidBeginEditing(_ textView: UITextView) {
        textView.text = ""
        textView.textColor = UIColor.darkGray
    }
    
    @IBAction func backBtnPressed(_ sender: Any) {
        performSegue(withIdentifier: GO_TO_CATEGORYVC, sender: self)
    }
}
