//
//  CategoryVC.swift
//  Metra
//
//  Created by Zelal-Ezaldeen on 2/10/19.
//  Copyright © 2019 Metra Company. All rights reserved.
//

import UIKit
import Firebase

class CategoryVC: UIViewController, UITableViewDataSource, UITableViewDelegate {
    
    //Outlets
      @IBOutlet weak var categoryTable: UITableView!
    //Variables
    var window: UIWindow?
    private var handle: AuthStateDidChangeListenerHandle?

  
    override func viewDidLoad() {
        super.viewDidLoad()
        categoryTable.dataSource = self
        categoryTable.delegate = self
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return DataService.instance.getCategories().count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if let cell = tableView.dequeueReusableCell(withIdentifier: CATEGORY_CELL) as? CategoryCell {
            let category = DataService.instance.getCategories()[indexPath.row]
             cell.updateViews(category: category)
            return cell
        } else {
            return CategoryCell()
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let category = DataService.instance.getCategories()[indexPath.row]
        handle = Auth.auth().addStateDidChangeListener({ (auth, user) in
            if user == nil {
                let storyboard = UIStoryboard(name: "Main", bundle: nil)
                let loginVC = storyboard.instantiateViewController(withIdentifier: AUTH_VC)
                self.present(loginVC, animated: true, completion: nil)
            } else if indexPath.row == 1 {
               self.performSegue(withIdentifier: GO_TO_ARKIT, sender: category)
            } else if indexPath.row == 3 {
                UIApplication.shared.open(URL(string: "https://ies-constructions.com/canvas.html")! as URL, options: [:], completionHandler: nil)
                
            } else if indexPath.row == 0 {
                self.performSegue(withIdentifier: GO_TO_PRODUCTSVC , sender: category)
            } else if indexPath.row == 2 {
                self.performSegue(withIdentifier: GO_TO_DESIGNSVC, sender: category)
            }
            })
       
    }
    
//    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
//        if let addProductVC = segue.destination as? ProductsVC {
//            assert(sender as? Category != nil)
//            addProductVC.initProducts(category: sender as! Category)
//        }
//       
//    }
    

}
