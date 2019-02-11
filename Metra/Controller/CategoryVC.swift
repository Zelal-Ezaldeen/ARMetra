//
//  CategoryVC.swift
//  Metra
//
//  Created by Zelal-Ezaldeen on 2/10/19.
//  Copyright © 2019 Metra Company. All rights reserved.
//

import UIKit

class CategoryVC: UIViewController, UITableViewDataSource, UITableViewDelegate {
  
    @IBOutlet weak var categoryTable: UITableView!
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
        performSegue(withIdentifier: GO_TO_PRODUCT, sender: category)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let productVC = segue.destination as? ProductsVC {
            assert(sender as? Category != nil)
            productVC.initProducts(category: sender as! Category)
        }
    }
    

}
