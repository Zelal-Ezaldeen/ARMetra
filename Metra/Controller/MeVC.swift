//
//  MeVC.swift
//  Metra
//
//  Created by Zelal-Ezaldeen on 1/18/19.
//  Copyright © 2019 Metra Company. All rights reserved.
//

import UIKit
import Firebase

class MeVC: UIViewController {

    //Outlets
    @IBOutlet weak var imageProfile: UIImageView!
    @IBOutlet weak var emailLbl: UILabel!
    @IBOutlet weak var tableView: UITableView!
    override func viewDidLoad() {
        super.viewDidLoad()
      
    }
 
    @IBAction func logoutBtnPressed(_ sender: Any) {
        //Signout code
        //Log out user and send them back to the WelcomeVC
        do {
            try Auth.auth().signOut()
            self.performSegue(withIdentifier: TO_WELCOMEVC , sender: nil)
        } catch {
            print("حدث خطأ في تسجيل الخروج")
        }
        
    }
}
