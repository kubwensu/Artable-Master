//
//  ProductCell.swift
//  artable
//
//  Created by Kubwensu mambwe on 2020/01/05.
//  Copyright © 2020 Kubwensu mambwe. All rights reserved.
//

import UIKit
import Kingfisher

protocol ProductCellDelegate : class {
    func productFavorited(product: Product)
    func addToCart (product: Product)
}

class ProductCell: UITableViewCell {

    @IBOutlet weak var favoriteButton: UIButton!
    @IBOutlet weak var productPrice: UILabel!
    @IBOutlet weak var productTitle: UILabel!
    @IBOutlet weak var productImage: RoundedImageView!
    
    weak var delegate : ProductCellDelegate?
    private var product : Product!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func configureCell(product: Product, delegate: ProductCellDelegate) {
        self.product = product
        self.delegate = delegate
        productTitle.text = product.name
        
        if let url =  URL(string: product.imageURL) {
            let placeholder = UIImage(named: "placeholder")
            productImage.kf.indicatorType = .activity
            let options : KingfisherOptionsInfo = [KingfisherOptionsInfoItem.transition(.fade(0.2))]
            productImage.kf.setImage(with: url, placeholder: placeholder, options: options)

        }
        
        
        let formatter = NumberFormatter()
        formatter.numberStyle = .currency
        if let price = formatter.string(from: product.price as NSNumber) {
            productPrice.text = price
            
        }
        
        if UserService.favorites.contains(product) {
            //If it is a favorite
            favoriteButton.setImage(UIImage(named: "filled_star"), for: .normal)
        }else{
            favoriteButton.setImage(UIImage(named: "empty_star"), for: .normal)
        }
    }
    
    
    @IBAction func favoriteButtonClicked(_ sender: Any) {
             delegate?.productFavorited(product: product )
    }
    
    @IBAction func addToCartButtonClicked(_ sender: Any) {
        delegate?.addToCart(product: product)
    }
    
    
}
