//
//  CartItemCell.swift
//  artable
//
//  Created by Kubwensu mambwe on 2020/01/10.
//  Copyright © 2020 Kubwensu mambwe. All rights reserved.
//

import UIKit

protocol CartItemCellDelegate : class {
    func removeItem(product : Product)
    
}

class CartItemCell: UITableViewCell {
    //Outlets
    @IBOutlet weak var productImage: UIImageView!
    @IBOutlet weak var productTitleLabel: UILabel!
    @IBOutlet weak var removeItemButton: UIButton!
    
    //Outlets
    private var item : Product!
    weak var delegate : CartItemCellDelegate?
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func configureCell(product: Product, delegate: CartItemCellDelegate) {
        self.delegate = delegate
        self.item = product
        
        let formatter = NumberFormatter()
        formatter.numberStyle = .currency
        
        if let price = formatter.string(from: product.price as NSNumber) {
            productTitleLabel.text = "\(product.name) \(price)"
        }
        
        if let url = URL(string: product.imageURL) {
            productImage.kf.setImage(with: url)
        }
        
    }
    
    @IBAction func removeItemButtonClicked(_ sender: Any) {
    }
    
}
