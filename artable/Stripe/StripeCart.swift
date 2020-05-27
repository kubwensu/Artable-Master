//
//  StripeCart.swift
//  artable
//
//  Created by Kubwensu mambwe on 2020/01/10.
//  Copyright © 2020 Kubwensu mambwe. All rights reserved.
//

import Foundation

let StripeCart = _StripeCart()

final class _StripeCart {
    
    var cartItems = [Product]()
    private let stripeCreditCardCut = 0.029
    private let flatFeeCents = 30
    var shippingFees = 0
    
    //Variables for subtotal, processing fees, total
    var subTotal : Int {
        
        var amount = 0
        for item in cartItems {
            let pricePennies = Int(item.price * 100)
            amount += pricePennies
        }
        return amount
    }
    
    var processingFees : Int {
        if subTotal == 0 {
            return 0
        }else{
            let sub = Double(subTotal)
            let feesAndSub = Int(sub * stripeCreditCardCut) + flatFeeCents
            return feesAndSub
        }

    }
    
    var total : Int {
        return subTotal + processingFees + shippingFees
    }
    
    func addItemToCart(item: Product) {
        cartItems.append(item)
    }
    
    func removeItemFromCart(item: Product) {
        if let index = cartItems.firstIndex(of: item) {
            cartItems.remove(at: index)
        }
    }
    
    func clearCart() {
        cartItems.removeAll()
    }
    
//    func penniesToFormattedCurrency() -> String {
//        // if the int this function is being called on is 1234
//        // dollars = 1234/100 = $12.34
//        let dollars = Double(self) / 100
//        let formatter = NumberFormatter()
//        formatter.numberStyle = .currency
//
//        if let dollarString = formatter.string(from: dollars as NSNumber) {
//            return dollarString
//        }
//
//        return "$0.00"
//    }

    
}
