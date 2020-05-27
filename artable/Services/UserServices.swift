//
//  UserServices.swift
//  artable
//
//  Created by Kubwensu mambwe on 2020/01/09.
//  Copyright © 2020 Kubwensu mambwe. All rights reserved.
//

import Foundation
import Firebase

let UserService = _UserService()


final class _UserService {
    
    //Variables
    
    var user : User = User()
    var favorites : [Product] = [Product]()
    var auth = Auth.auth()
    let db = Firestore.firestore()
    var userListener : ListenerRegistration? = nil
    var favsListener : ListenerRegistration? = nil
    
    
    var isGuest : Bool {
        
        guard let user = auth.currentUser else {
            return true
        }
        
        if user.isAnonymous {
            return true
        }else{
            return false
        }
    }
    
    func getCurrentUser() {
        guard let authUser = auth.currentUser else {return}
        
        let userRef = Firestore.firestore().collection("users").document(authUser.uid)
        let userListener = userRef.addSnapshotListener { (snap, error) in
            if let error = error {
                debugPrint(error.localizedDescription)
                return
            }
            
            guard let data = snap?.data() else {return}
            let user = User.init(data: data)
        }
        
        let favsRef = userRef.collection("Favorites")
        let favsListener = favsRef.addSnapshotListener { (snap, error) in
            if let error = error {
                debugPrint(error.localizedDescription)
                return
            }
            
            snap?.documents.forEach({ (document) in
                let favorite = Product.init(data: document.data())
                self.favorites.append(favorite)
            })
            
        }
    }
    
    func favoriteSelected(product: Product) {
        let favsRef = Firestore.firestore().collection("users").document(user.id).collection("favorites")
        
        if favorites.contains(product) {
             //we remove it as a favorite
            favorites.removeAll{$0 == product}
            favsRef.document(product.id).delete()
        }else{
            //We add it to the favorites
            favorites.append(product)
            let data = Product.modelData(product: product)
            favsRef.document(product.id).setData(data)
        }
    }
    
    func logOutUser() {
        userListener?.remove()
        userListener = nil
        favsListener?.remove()
        favsListener = nil
        user = User()
        favorites.removeAll()
    }
}

