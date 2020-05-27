//
//  Firebase +  extensions.swift
//  artable
//
//  Created by Kubwensu mambwe on 2020/01/04.
//  Copyright © 2020 Kubwensu mambwe. All rights reserved.
//

import Firebase

extension Auth {
    func handleFireAuthError(error : Error, vc: UIViewController) {
           if let errorCode = AuthErrorCode(rawValue: error._code) {
            let alert = UIAlertController(title: "Error", message: error.localizedDescription, preferredStyle: .alert)
            let action = UIAlertAction(title: "OK", style: .default, handler: nil)
            alert.addAction(action)
            vc.present(alert, animated: true , completion: nil)
            }
        }
}

extension AuthErrorCode {
    var errorMessage : String {
        switch self {
        case .emailAlreadyInUse:
            return "The email is already in use with another account"
        default:
            return "Something went wrong"
        }
    }
}
 
