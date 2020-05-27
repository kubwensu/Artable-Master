//
//  AddEditProductsVC.swift
//  artableadmin
//
//  Created by Kubwensu mambwe on 2020/01/09.
//  Copyright © 2020 Kubwensu mambwe. All rights reserved.
//

import UIKit
import Firebase

class AddEditProductsVC: UIViewController {
    //Outlets
    @IBOutlet weak var addButton: RoundedButtons!
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    @IBOutlet weak var productImageView: RoundedImageView!
    @IBOutlet weak var productDescription: UITextView!
    @IBOutlet weak var productPrice: UITextField!
    @IBOutlet weak var productName: UITextField!
    
    //Variables
    var selectedCategory : Category?
    var productToEdit : Product?
    var name : String = ""
    var price = 0.0
    var description: String = ""

    override func viewDidLoad() {
        super.viewDidLoad()
        let tap = UITapGestureRecognizer(target: self, action:#selector(imageTapped(_:)) )
        // Do any additional setup after loading the view.
        tap.numberOfTapsRequired = 1
//        productImageView.isUserInteractionEnabled = true
        productImageView.addGestureRecognizer(tap)
        
        //If we are editing a product

        if let productToEdit = productToEdit {
            productName.text = productToEdit.name
            productDescription.text = productToEdit.productDescription
            productPrice.text = productToEdit.price
            
            if let url = URL(string: productToEdit.imageURL) {
                productImageView.contentMode = .scaleAspectFill
                productImageView.kf.setImage(with: url)
            }
        }
    }
    
    @objc func imageTapped(_ tap: UITapGestureRecognizer) {
        launchImagePickingViewController()
    }
    

    @IBOutlet weak var addProductClicked: UILabel!
    
    //MARK:- Uploading image then document
    
    func UploadImageThenDocument() {
        guard let image = productImageView.image,
            let name = productName.text , !name.isEmpty,
            let description = productDescription.text, !description.isEmpty,
            let priceString = productPrice.text, !price.isEmpty,
            let price = Double(priceString) else {
                simpleAlert(title: "Error", message: "Please fill out all fields")
                return
        }
        self.name = name
        self.description = description
        self.price = price
        
        activityIndicator.startAnimating()

        //1:Turn image to data
        guard let imageData = image.jpegData(compressionQuality: 0.2) else {return}
        
        //2: Create and image reference
        let imageRef = Storage.storage().reference().child("/products/\(name).jpg")
        
        //3:Set the metadata
        let metaData = StorageMetadata()
        metaData.contentType = "image/jpg"
        
        //4: Upload the data
        imageRef.putData(imageData, metadata: metaData) { (metaData, error) in
            if let error = error {
                HandleError(error: error, msg: "Unable to upload image")
                return
            }
        }
        
        //5: Download URL
        imageRef.downloadURL { (url, error) in
            if let error = error{
                HandleError(error, "Unable to upload image")
                return
            }
            guard let url = url else {return}
            //6: Upload the new product document to the firestore database
            uploadDocument(url: url.absoluteString)
        }

    }
    
    func HandleError(_ error: Error, _ msg: String){
        debugPrint(error.localizedDescription)
        simpleAlert(title: "Error", message: msg)
        activityIndicator.stopAnimating()
    }
//MARK:- Uploading document to the database
    func  uploadDocument(url: String) {
        var docRef : DocumentReference!
        var product = Product.init(name: name, id: "", category: selectedCategory.id, price: price, productDescription: description, imageURL: url)
        
        if let productToEdit = productToEdit {
            //we are editing a product
            docRef = Firestore.firestore().collection("products").document(productToEdit.id)
            product.id = productToEdit.id
            
        }else{
            //we are creating a new product
            docRef = Firestore.firestore().collection("products").document()
            product.id = docRef.documentID
        }
        let data = Product.modelData(product: product)
        docRef.setData(data, merge: true) { (error) in
            if let error = error {
                HandleError(error, "Unable to upload document")
            }
            navigationController?.popViewController(animated: true)
        }
    }
    
}


//MARK:- Extensions
extension AddEditProductsVC: UIImagePickerControllerDel egate, UINavigationControllerDelegate {
    
    func launchImagePickingViewController() {
        let vc = UIImagePickerController()
        vc.delegate = self
        present(vc, animated: true, completion: nil)
    }
    
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        guard let image = info[.originalImage] as? UIImage else {return}
        productImageView.contentMode = .scaleAspectFill
        productImageView.image = image'
        dismiss(animated: true, completion: nil)
        
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        dismiss(animated: true, completion: nil)
    }
}
