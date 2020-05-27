//
//  CheckoutVC.swift
//  artable
//
//  Created by Kubwensu mambwe on 2020/01/10.
//  Copyright © 2020 Kubwensu mambwe. All rights reserved.
//

import UIKit
import Stripe
import FirebaseFunctions

class CheckoutVC: UIViewController, CartItemCellDelegate {

    
    
    //Outlets
    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var paymentMethodButton: UIButton!
    @IBOutlet weak var shippingMethodButton: UIButton!
    @IBOutlet weak var subTotalLabel: UILabel!
    @IBOutlet weak var processingFeeLabel: UILabel!
    @IBOutlet weak var shippingCostLabel: UILabel!
    @IBOutlet weak var totalLabel: UILabel!
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    
    //Variables
    var paymentContext : STPPaymentContext!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.register(UINib(nibName: "CartItemCell", bundle: nil), forCellReuseIdentifier: "CartItemCell")
        // Do any additional setup after loading the view.
    }
    
    func setUpPaymentInfo() {
        subTotalLabel.text = StripeCart.subTotal.penniesToFormattedCurrency()
        processingFeeLabel.text = StripeCart.processingFees.penniesToFormattedCurrency()
        shippingCostLabel.text = StripeCart.shippingFees.penniesToFormattedCurrency()
        totalLabel.text = StripeCart.total.penniesToFormattedCurrency()

    }
    
    func setupStripeConfig() {
        let config = STPPaymentConfiguration.shared()
//        config.createCardSource = true
        config.requiredBillingAddressFields = .none
        config.requiredShippingAddressFields = [.postalAddress]
        
        
                
        let customerContext = STPCustomerContext(keyProvider: StripeApi)
        paymentContext = STPPaymentContext(customerContext: customerContext, configuration: config, theme: .default())
        
        paymentContext.paymentAmount = StripeCart.total
        paymentContext.delegate = self
        paymentContext.hostViewController = self

    }

    @IBAction func placeOrderClicked(_ sender: Any) {
    }
    
    @IBAction func paymentMethodClicked(_ sender: Any) {
        paymentContext.pushPaymentOptionsViewController()
        activityIndicator.startAnimating()
    }
    @IBAction func shippingMethodClicked(_ sender: Any) {
        paymentContext.pushShippingViewController()
    }
    
    func removeItem(product: Product) {
        StripeCart.removeItemFromCart(item: product)
        tableView.reloadData()
        
    }
    
}

extension CheckoutVC: STPPaymentContextDelegate{
    func paymentContextDidChange(_ paymentContext: STPPaymentContext) {
        //selecting payment method
        
        if let paymentMethod = paymentContext.selectedPaymentOption {
            paymentMethodButton.setTitle(paymentMethod.label, for: .normal)
        }else{
            paymentMethodButton.setTitle("Select Method", for: .normal)
        }
        
        //selectin the shipping method
        
        if let shipmentMethod = paymentContext.selectedShippingMethod {
            shippingMethodButton.setTitle(shipmentMethod.label, for: .normal)
            StripeCart.shippingFees = Int(Double(truncating: shipmentMethod.amount) * 100)
            setUpPaymentInfo()
        }else{
            shippingMethodButton.setTitle("Select Method", for: .normal)
        }
    }
    
    func paymentContext(_ paymentContext: STPPaymentContext, didFailToLoadWithError error: Error) {
        activityIndicator.stopAnimating()
        
        let alert = UIAlertController(title: "Error", message: error.localizedDescription, preferredStyle: .alert)
        
        let cancel = UIAlertAction(title: "Cancel", style: .cancel) { (action) in
            self.navigationController?.popViewController(animated: true)
        }
        
        let retry = UIAlertAction(title: "Retry", style: .default) { (action) in
            self.paymentContext.retryLoading()
        }
        
        alert.addAction(cancel)
        alert.addAction(retry)
        present(alert, animated: true, completion: nil)
    }
    
    func paymentContext(_ paymentContext: STPPaymentContext, didCreatePaymentResult paymentResult: STPPaymentResult, completion: @escaping STPErrorBlock) {
        
        let idempotency = UUID().uuidString.replacingOccurrences(of: "-", with: "")
        let data : [String : Any] = [
            "total" : StripeCart.total,
            "customerId" : UserService.user.id,
            "idempotency" : idempotency
        ]
        
        Functions.functions().httpsCallable("createCharge").call(data) { (result, error) in
            if let error = error {
                debugPrint(error.localizedDescription)
                self.simpleAlert(title: "Error", message: "Unable to create charge")
                completion(error)
                return
            }
            StripeCart.clearCart()
            self.tableView.reloadData()
            self.setUpPaymentInfo()
            completion(nil)
        }
    }
    
    func paymentContext(_ paymentContext: STPPaymentContext, didFinishWith status: STPPaymentStatus, error: Error?) {
        let title : String
        let message : String
        
        switch status {
        case .error:
            activityIndicator.stopAnimating()
            title = "Error"
            message = error?.localizedDescription as? String ?? ""
        case .success:
            title = "Success"
            message = "Thank you for your purchase"
        case .userCancellation:
            return
        default:
            return
        }
        
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        let alertAction = UIAlertAction(title: "Ok", style: .default) { (action) in
            self.navigationController?.popViewController(animated: true)
        }
        alert.addAction(alertAction)
        present(alert, animated: true, completion: nil)
    }
    
    func paymentContext(_ paymentContext: STPPaymentContext, didUpdateShippingAddress address: STPAddress, completion: @escaping STPShippingMethodsCompletionBlock) {
        let upsGround = PKShippingMethod()
        upsGround.amount = 0
        upsGround.label = "UpsGround"
        upsGround.detail = "Arrives in 3-5 days"
        upsGround.identifier = "ups_ground"
        
        let fedEx = PKShippingMethod()
        fedEx.amount = 6.99
        fedEx.label = "fedEx"
        fedEx.detail = "Arrives next day"
        fedEx.identifier = "fedex"
        
        if address.country == "ZA" {
            completion(.valid, nil, [fedEx, upsGround], fedEx)
        }else {
            completion(.invalid, nil, nil, nil)
        }
    }
    
    
}

extension CheckoutVC: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return StripeCart.cartItems.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if let cell = tableView.dequeueReusableCell(withIdentifier: "CartItemCell", for: indexPath)  as? CartItemCell {
            
            let product = StripeCart.cartItems[indexPath.row]
            cell.configureCell(product: product, delegate: self)
            return cell
        }
        return UITableViewCell()
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 100
    }
    
    
}
