//
//  AdminProductsVC.swift
//  artableadmin
//
//  Created by Kubwensu mambwe on 2020/01/09.
//  Copyright © 2020 Kubwensu mambwe. All rights reserved.
//

import UIKit

class AdminProductsVC: ProductsVC {
    
    var selectedProduct : Product?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let editCategoryBtn = UIBarButtonItem(title: "Edit Category", style: .plain, target: self, action: #selector(editCategory))
        let editProductBtn = UIBarButtonItem(title: "+ Product", style: .plain, target: self, action: #selector(editProduct))
        navigationItem.setRightBarButtonItems([editCategoryBtn, editProductBtn]?, animated: false)
        // Do any additional setup after loading the view.
    }
    
    @objc func editCategory() {
        //Edit Category
        performSegue(withIdentifier: "toEditCategoriesVC", sender: self)
    }
    
    @objc func editProduct() {
        //Edit product
        performSegue(withIdentifier: "toEditProductsVC", sender: self)
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        selectedProduct = products[indexPath.row]
        performSegue(withIdentifier: "toEditProductsVC", sender: self)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier = "toEditProductsVC" {
            if let destination = segue.destination as? AddEditProductsVC {
                destination.selectedCategory = category
                destination.productToEdit = selectedProduct
                
            }else if segue.identifier = "toEditCategoriesVC" {
                if let destination = segue.destination as? AddEditCategoriesVC{
                    destination.categoryToEdit = category
                }
            }
        }
    }
    
    override func productFavorited(product: Product) {
        return
    }
    override func addToCart(product: Product) {
        return
    }
}

