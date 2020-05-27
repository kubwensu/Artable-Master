//
//  Products.swift
//  artable
//
//  Created by Kubwensu mambwe on 2020/01/05.
//  Copyright © 2020 Kubwensu mambwe. All rights reserved.
//

import Foundation
import FirebaseFirestore

struct Product {
    var name : String
    var id : String
    var category : String
    var price : Double
    var productDescription : String
    var imageURL : String
    var timeStamp : Timestamp
    var stock : Int
    
    
    init(name : String,
       id : String,
       category : String,
       price : Double,
       productDescription : String,
       imageURL : String,
       timeStamp : Timestamp = Timestamp(),
       stock : Int = 0){
        
        self.name = name
        self.id = id
        self.category = category
        self.price = price
        self.productDescription = productDescription
        self.imageURL = imageURL
        self.timeStamp = timeStamp
        self.stock = stock
    }
    
    init(data : [String: Any]) {
        name = data["name"] as? String ?? ""
        id = data["id"] as? String ?? ""
        category = data["category"] as? String ?? ""
        price = data["price"] as? Double ?? 0.0
        productDescription = data["productDescription"] as? String ?? ""
        imageURL = data["imageURL"] as? String ?? ""
        timeStamp = data["timestamp"] as? Timestamp ?? Timestamp()
        stock = data["stock"] as? Int ?? 0
    }
    
    static func modelData (product: Product) -> [String:Any]  {
        let data : [String :Any] = [
        "name" : product.name,
        "id" : product.id,
        "category" : product.category,
        "price" : product.price,
        "productDescription" : product.productDescription,
        "imageURL" : product.imageURL,
        "timeStamp" : product.timeStamp,
        "stock" : product.stock ]
        return data
    }
    
}

extension Product : Equatable {
    static func == (lhs : Product, rhs: Product) -> Bool {
        return lhs.id == rhs.id
    }
}
