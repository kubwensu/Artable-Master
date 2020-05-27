//
//  Extensions.swift
//  artable
//
//  Created by Kubwensu mambwe on 2019/12/20.
//  Copyright © 2019 Kubwensu mambwe. All rights reserved.
//

import Foundation
import UIKit
import Firebase

extension String {
    var isNotEmpty : Bool {
        return !isEmpty
    }
}

extension UIViewController {
    //MARK:- moved handling firebase error to firebase extensions file
//        func handleFireAuthError(error : Error) {
//           if let errorCode = AuthErrorCode(rawValue: error._code) {
//            let alert = UIAlertController(title: "Error", message: error.localizedDescription, preferredStyle: .alert)
//            let action = UIAlertAction(title: "OK", style: .default, handler: nil)
//            alert.addAction(action)
//            present(alert, animated: true , completion: nil)
//            }
//        }
    func simpleAlert(title : String , message : String) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
        present(alert, animated: true, completion: nil)
    }

   //MARK:- Presenting alert without customizing firebase messages
//    func handleFireAuthError(error : Error) {
//        let alert = UIAlertController(title: "Error", message: error.localizedDescription, preferredStyle: .alert)
//        let action = UIAlertAction(title: "OK", style: .default, handler: nil)
//        alert.addAction(action)
//        present(alert, animated: true , completion: nil)
//    }
    
    
}
//MARK:- moved to firebase file 
//extension AuthErrorCode {
//    var errorMessage : String {
//        switch self {
//        case .emailAlreadyInUse:
//            return "The email is already in use with another account"
//        default:
//            return "Something went wrong"
//        }
//    }
//}

extension Int {
    
    func penniesToFormattedCurrency() -> String {
        // if the int this function is being called on is 1234
        // dollars = 1234/100 = $12.34
        let dollars = Double(self) / 100
        let formatter = NumberFormatter()
        formatter.numberStyle = .currency
        
        if let dollarString = formatter.string(from: dollars as NSNumber) {
            return dollarString
        }
        
        return "$0.00"
    }
}
