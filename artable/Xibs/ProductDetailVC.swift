//
//  ProductDetailVC.swift
//  artable
//
//  Created by Kubwensu mambwe on 2020/01/08.
//  Copyright © 2020 Kubwensu mambwe. All rights reserved.
//

import UIKit

class ProductDetailVC: UIViewController {
    
    //Outlets
    @IBOutlet weak var productTitle: UILabel!
    @IBOutlet weak var productPrice: UILabel!
    @IBOutlet weak var productDescription: UILabel!
    @IBOutlet weak var bgView: UIVisualEffectView!
    @IBOutlet weak var productImage: UIImageView!
    
    var product : Product!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        productTitle.text = product.name
        productDescription.text = product.productDescription
        
        let formatter = NumberFormatter()
        formatter.numberStyle = .currency
        if let price = formatter.string(from: product.price as NSNumber) {
            productPrice.text = price
            
            let tap = UITapGestureRecognizer(target: self, action: #selector(dismissProduct))
            tap.numberOfTapsRequired = 1
            bgView.addGestureRecognizer(tap)
        }
    }
    
    @objc func dismissProduct() {
        dismiss(animated: true, completion: nil)
    }
    
    // Do any additional setup after loading the view.
    
    
    @IBAction func addToCartClicked(_ sender: Any) {
        if UserService.isGuest {
            self.simpleAlert(title: "Hi Friend!", message: "This is a user only feature, please create a registered user to take advantage of all our features")
            return
        }
        StripeCart.addItemToCart(item: product)
        dismiss(animated: true, completion: nil)
    }
    
    @IBAction func keepShoppingClicked(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
    
}


