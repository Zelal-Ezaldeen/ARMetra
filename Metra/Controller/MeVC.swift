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
        let logoutPopup = UIAlertController(title: "تسجيل الخروج؟", message: "هل تريد تسجيل الخروج؟", preferredStyle: .actionSheet)
        
        let logoutAction = UIAlertAction(title: "تسجيل الخروج؟", style: .destructive) { (buttonTapped) in
            
            do {
                try Auth.auth().signOut()
                let authVC = self.storyboard?.instantiateViewController(withIdentifier: AUTH_VC) as? AuthVC
                self.present(authVC!, animated: true, completion: nil)
            } catch {
                print(error)
            }
        }
        logoutPopup.addAction(logoutAction)
        present(logoutPopup, animated: true, completion: nil)
    }
}
