//
//  CategoryCollectionViewCell.swift
//  artable
//
//  Created by Kubwensu mambwe on 2020/01/04.
//  Copyright © 2020 Kubwensu mambwe. All rights reserved.
//

import UIKit
import Kingfisher

class CategoryCollectionViewCell: UICollectionViewCell {

    @IBOutlet weak var categoryImage: UIImageView!
    @IBOutlet weak var categoryLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        categoryImage.layer.cornerRadius = 5.0
    }
    
    func configureCell(category: Category) {
        categoryLabel.text = category.name
        if let url = URL(string: category.imageURL) {
            let placeholder = UIImage(named: "placeholder")
            let options : KingfisherOptionsInfo = [KingfisherOptionsInfoItem.transition(.fade(0.1))]
            categoryImage.kf.indicatorType = .activity 
            categoryImage.kf.setImage(with: url, placeholder: placeholder, options: options)
        }
    }

}
