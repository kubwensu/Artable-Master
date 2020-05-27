//
//  ViewController.swift
//  artableadmin
//
//  Created by Kubwensu mambwe on 2019/12/15.
//  Copyright © 2019 Kubwensu mambwe. All rights reserved.
//

import UIKit

class AdminVC: HomeVC {

    override func viewDidLoad() {
        super.viewDidLoad()
        navigationItem.leftBarButtonItem?.isEnabled = false
        
        let addCategoryBtn = UIBarButtonItem(title: "Add Category", style: .plain, target: self, action: #selector(addCategory))
        navigationItem.rightBarButtonItem = addCategoryBtn
        
    }
    
    @objc func addCategory (){
        performSegue(withIdentifier: "toAddEditCategoriesVC", sender: self)
    }


}

