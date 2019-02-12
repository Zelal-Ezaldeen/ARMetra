//
//  ProductsVC.swift
//  Metra
//
//  Created by Zelal-Ezaldeen on 2/11/19.
//  Copyright © 2019 Metra Company. All rights reserved.
//

import UIKit

class ProductsVC: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource {
    
   //Outlets
    
    @IBOutlet weak var productTitleLbl: UILabel!
    @IBOutlet weak var productsCollection: UICollectionView!
    private(set) public var products = [Product]()
   
    override func viewDidLoad() {
        super.viewDidLoad()
        productsCollection.dataSource = self
        productsCollection.delegate = self
    }
    
    func initProducts(category: Category)  {
        products = DataService.instance.getProducts(forCategoryTitle: category.title)
        //productTitleLbl.text = category.title
        print(category.title)
     
      
        
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return products.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if let cell = collectionView.dequeueReusableCell(withReuseIdentifier: PRODUCT_CELL, for: indexPath) as? ProductCell  {
            let product = products[indexPath.row]
            
            cell.updateViews(product: product)
      print(product)
            return cell
        }
      
        return ProductCell()
    }

    @IBAction func backBtnPressed(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
}
