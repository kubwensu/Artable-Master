//
//  ProductsVC.swift
//  artable
//
//  Created by Kubwensu mambwe on 2020/01/05.
//  Copyright © 2020 Kubwensu mambwe. All rights reserved.
//

import UIKit
import Firebase

class ProductsVC: UIViewController, ProductCellDelegate {

    

    //Outlets
    @IBOutlet weak var tableView: UITableView!
    
    // Variables
    var products = [Product]()
    var category: Category!
    var listener: ListenerRegistration!
    var showFavorites = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.register(UINib(nibName: "ProductCell", bundle: nil), forCellReuseIdentifier: "ProductCell")
        // Do any additional setup after loading the view.
    }
    
    func setupQuery() {
        var ref : Query!
        if showFavorites {
            ref = Firestore.firestore().collection("users").document(UserService.user.id).collection("favorites")
        }else{
            ref = Firestore.firestore().collection("products").whereField("category", isEqualTo: category.id).order(by: "timestamp", descending: true)
        }
        
        listener = ref.addSnapshotListener({ (snap, error) in
            
            if let error = error {
                debugPrint(error.localizedDescription)
            }
            snap?.documentChanges.forEach({ (change) in
                let data = change.document.data()
                let product = Product.init(data: data)
                
                switch change.type {
                case .added:
                    self.documentAdded(change: change, product: product)
                case .modified:
                    self.documentModified(change: change, product: product)
                case .removed:
                    self.documentRemoved(change: change)
                }
            })
            
        })
    }
    
    func productFavorited(product: Product) {
        if UserService.isGuest {
            self.simpleAlert(title: "Hi Friend!", message: "This is a user only feature, please create a registered user to take advantage of all our features")
            return
        }
        UserService.favoriteSelected(product: product)
        guard let index = products.firstIndex(of: product) else {return}
        tableView.reloadRows(at: [IndexPath(row: index, section: 0)], with: .automatic)
    }
    
    func addToCart(product: Product) {
        if UserService.isGuest {
            self.simpleAlert(title: "Hi Friend!", message: "This is a user only feature, please create a registered user to take advantage of all our features")
            return
        }
        StripeCart.addItemToCart(item: product)
    }
    
    func documentAdded(change: DocumentChange, product: Product)  {
        let newIndex = Int(change.newIndex)
        products.insert(product, at: newIndex)
        tableView.insertRows(at: [IndexPath(row: newIndex, section: 0)], with: UITableView.RowAnimation.automatic)
    }
    
    func documentModified(change: DocumentChange, product: Product) {
        //if changed data but not position
        if change.newIndex == change.oldIndex {
            let index = Int(change.newIndex)
            products[index] = product
            tableView.reloadRows(at: [IndexPath(row: index, section: 0)], with: UITableView.RowAnimation.automatic)
        }
        //If changed both position and property
        let newIndex = Int(change.newIndex)
        let oldIndex = Int(change.oldIndex)
        products.remove(at: oldIndex)
        products.insert(product, at: newIndex)
        tableView.moveRow(at: IndexPath(row: oldIndex, section: 0), to: IndexPath(row: newIndex, section: 0))
    }
    
    func documentRemoved(change: DocumentChange) {
        let oldIndex = Int(change.oldIndex)
        products.remove(at: oldIndex)
        tableView.deleteRows(at: [IndexPath(row: oldIndex, section: 0)], with: UITableView.RowAnimation.automatic)
        
    }
     
}

extension ProductsVC: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return products.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if let cell = tableView.dequeueReusableCell(withIdentifier: "ProductCell", for: indexPath) as? ProductCell {
            cell.configureCell(product: products[indexPath.item], delegate: self)
            return cell
        }
        return UITableViewCell()
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 200
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let vc = ProductDetailVC()
        let selectedProduct = products[indexPath.row]
        vc.product = selectedProduct
        vc.modalTransitionStyle = .crossDissolve
        vc.modalPresentationStyle = .overFullScreen
        present(vc, animated: true, completion: nil)
        
    }
    
}
