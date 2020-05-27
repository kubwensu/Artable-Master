//
//  RoundedViews.swift
//  artable
//
//  Created by Kubwensu mambwe on 2019/12/18.
//  Copyright © 2019 Kubwensu mambwe. All rights reserved.
//

import Foundation
import UIKit

class RoundedButtons : UIButton {
    override func awakeFromNib() {
        super.awakeFromNib()
        layer.cornerRadius = 5.0
    }
}

class RoundedShadowViews: UIView {
    override func awakeFromNib() {
        super.awakeFromNib()
        layer.cornerRadius = 5.0
        layer.shadowColor = #colorLiteral(red: 0.2040559649, green: 0.7372421622, blue: 0.6007294059, alpha: 1)
        layer.shadowOpacity = 0.4
        layer.shadowOffset = CGSize.zero
        layer.shadowRadius = 3
    }
}

class RoundedImageView: UIImageView {
    override func awakeFromNib() {
        super.awakeFromNib()
        layer.cornerRadius = 5.0
    }
}


