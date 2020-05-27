//
//  RegisterVC.swift
//  artable
//
//  Created by Kubwensu mambwe on 2019/12/17.
//  Copyright © 2019 Kubwensu mambwe. All rights reserved.
//

import UIKit
import Firebase

class RegisterVC: UIViewController {

    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    @IBOutlet weak var confirmPasswordText: UITextField!
    @IBOutlet weak var passwordText: UITextField!
    @IBOutlet weak var emailText: UITextField!
    @IBOutlet weak var usernameText: UITextField!
    @IBOutlet weak var passCheckImage: UIImageView!
    @IBOutlet weak var confirmPassCheckImage: UIImageView!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        passwordText.addTarget(self, action: #selector(textFieldDidChange(_:)), for: UIControl.Event.editingChanged)
        confirmPasswordText.addTarget(self, action: #selector(textFieldDidChange(_:)), for: UIControl.Event.editingChanged)

        // Do any additional setup after loading the view.
    }
    
    @objc func textFieldDidChange (_ textField: UITextField) {
        //Make it so that it changes the check mark color
        
        guard let passText = passwordText.text else {return}
                
        //if started typing in the confirm password
        
        if textField == confirmPasswordText {
            confirmPassCheckImage.isHidden = false
            passCheckImage.isHidden = false
        }else {
            if passText.isEmpty == true {
                confirmPassCheckImage.isHidden = true
                passCheckImage.isHidden = true
                confirmPasswordText.text = ""
            }
        }
        
        if passwordText.text == confirmPasswordText.text {
            passCheckImage.image = UIImage(named: "green_check")
            confirmPassCheckImage.image = UIImage(named: "green_check")
        }else{
            passCheckImage.image = UIImage(named: "red_check")
            confirmPassCheckImage.image = UIImage(named: "red_check")
        }
        
    }
    
    
    @IBAction func registerButtonClicked(_ sender: Any) {
        guard let email = emailText.text, !email.isEmpty,
            let username = usernameText.text, !username.isEmpty,
            let password = passwordText.text, !password.isEmpty else {
                simpleAlert(title: "Error", message: "Please fill out all forms")
                return} 
        
        guard let confirmPassword = confirmPasswordText.text, confirmPassword == password else {
            simpleAlert(title: "Error", message: "Passwords do not match" )
            return}
        
        activityIndicator.startAnimating()

//MARK:- Creating new users
        Auth.auth().createUser(withEmail: email, password: password) { (result, error) in
            if let error = error {
                Auth.auth().handleFireAuthError(error: error, vc:self)
                debugPrint(error)
                return
            }
            
            guard let firUser =  result?.user else {return}
//            let artUser = firUser.user.uid
            let user = User.init(id: firUser.uid, email: email, username: username, stripeId: "")
            
            //Create new user
            self.createFirestoreUser(user: user)
            
        }
    }
    
    func createFirestoreUser(user : User) {
        //1 Create document reference
        let userRef = Firestore.firestore().collection("users").document(user.id)
       
        //2 Create model data
        let data = User.modelToData(user: user)
        
        //3 Upload document
        userRef.setData(data, merge: true) { (error) in
            if let error = error {
                Auth.auth().handleFireAuthError(error: error, vc: self)
                debugPrint("Error signing in \(error.localizedDescription)")
            }else{
                self.dismiss(animated: true, completion: nil)
            }
            self.activityIndicator.stopAnimating()
    }
        
//MARK:- Linking users anonymous and Email/Password credentials
//        guard let authUser = Auth.auth().currentUser else {return}
//
//        let credential = EmailAuthProvider.credential(withEmail: email, link: password)
//        authUser.link(with: credential) { (response, Error) in
//            if let error = Error {
//                Auth.auth().handleFireAuthError(error: error, vc:self)
//                debugPrint(error)
//                return
//            }
//            self.activityIndicator.stopAnimating()
//            self.dismiss(animated: true, completion: nil)
//        }
        
        //MARK:- Creating user using regular email and password
//
//        Auth.auth().createUser(withEmail: email, password: password) { (AuthDataResult, Error) in
//
//            if let error = Error {
//                debugPrint(error)
//                return
//            }
//            self.activityIndicator.stopAnimating()
//            self.dismiss(animated: true, completion: nil)
//        }
        
    }
    

}
