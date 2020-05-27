//
//  ForgotPasswordVC.swift
//  artable
//
//  Created by Kubwensu mambwe on 2019/12/20.
//  Copyright © 2019 Kubwensu mambwe. All rights reserved.
//

import UIKit
import Firebase

class ForgotPasswordVC: UIViewController {
    
    //OUTLETS
    @IBOutlet weak var emailText: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
     
    @IBAction func cancelClicked(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
    
    @IBAction func resetClicked(_ sender: Any) {
        guard let email =  emailText.text, !email.isEmpty else {
            simpleAlert(title: "Error", message: "Please enter email")
            return
        }
        Auth.auth().sendPasswordReset(withEmail: email) { (Error) in
            if let error = Error {
                debugPrint(error)
                Auth.auth().handleFireAuthError(error: error, vc:self)
                return
            }
            self.dismiss(animated: true, completion: nil)
        }
    }
    
}
