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
    

}
