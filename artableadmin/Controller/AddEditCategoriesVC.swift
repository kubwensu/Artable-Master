//
//  AddEditCategoriesVC.swift
//  artableadmin
//
//  Created by Kubwensu mambwe on 2020/01/08.
//  Copyright © 2020 Kubwensu mambwe. All rights reserved.
//

import UIKit
import Firebase

class AddEditCategoriesVC: UIViewController {
    
    @IBOutlet weak var nameText: UILabel!
    @IBOutlet weak var categoryImage: RoundedImageView!
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    @IBOutlet weak var addButton: RoundedButtons!
    
    var categoryToEdit : Category?
    
    override func viewDidLoad() {
        super.viewDidLoad()
         
        let tap = UITapGestureRecognizer(target: self, action: #selector(imageTapped))
        tap.numberOfTapsRequired = 1
        
        //        categoryImage.isUserInteractionEnabled = true
        categoryImage.addGestureRecognizer(tap)
        
        //If we are editing CategoryToEdit will not be = nil!
        if let category = categoryToEdit {
            nameText.text = category.name
            addButton.setTitle("Save Changes", for: .normal)

            if let url = URL(string: category.imageURL){
                categoryImage.contentMode = .scaleAspectFill
            categoryImage.kf.setImage(with: url)
            }
        }
        
    }
    
    @objc func imageTapped(_ tap: UITapGestureRecognizer) {
        launchImagePicker()
    }
    
    
    
    @IBAction func addCategoryClicked(_ sender: Any) {
        UploadImageThenDocument()
    }
    
    //MARK:- Uploading Image Programmatically to cloud Storage

    func UploadImageThenDocument() {
        guard let image = categoryImage.image,
            let categoryName = nameText.text, !categoryName.isEmpty else {
                simpleAlert(title: "Error", message: "Must add category image and name")
                return
        }
        
        activityIndicator.startAnimating()

        //1:Turn image into data
        guard let imageData  = image.jpegData(compressionQuality: 0.2) else {return}
        
        //2:Create an image storage reference -> location in firestorage for it to be stored
        let imageRef = Storage.storage().reference().child("/categoryImages/\(categoryName).jpg")
        
        //3:Set the metadata
        let metadata = StorageMetadata()
        metadata.contentType = "image/jpg"
        
        //4: Upload the data
        imageRef.putData(imageData, metadata: metadata) { (data, error) in
            if let error = error {
                Handle(error)
                return
            }
            
        }
        //5:Once the image is uploaded retrieve the metadata
        imageRef.downloadURL { (url, error) in
            if let error = error {
                Handle(error)
                return
            }
            
            guard let url = url else {return}
            //6:Upload new category document to the Firestore categories collection
            uploadTheDocument(url: url.absoluteString)
        }
        
    }
    
    //Simple Alert function
     func Handle(_ error: Error) {
        debugPrint(error.localizedDescription)
        simpleAlert(title: "Error", message: "Unable to upload image")
        activityIndicator.stopAnimating()
    }
    
    //MARK:- Uploading the document to the database
    func uploadTheDocument(url: String) {
        var docRef: DocumentReference!
        var category = Category.init(name: nameText.text!, id: "", imageURL: url, timestamp: Timestamp())
        
        if let categoryToEdit = categoryToEdit {
            //We are editing
            docRef = Firestore.firestore().collection("categories").document(categoryToEdit.id)
            category.id = categoryToEdit.id
        }else{
            //We are writing new data to server(New Category)
            docRef = Firestore.firestore().collection("categories").document()
            category.id = docRef.documentID
        }

        let data = Category.modelToData(category: category)
        docRef.setData(data, merge: true) { (error) in
            if let error = error {
                debugPrint(error.localizedDescription)
                simpleAlert(title: "Error", message: "Unable to upload image")
                activityIndicator.stopAnimating()
                return
            }
            self.navigationController?.popViewController(animated: true)
        }
    }
}
//MARK:- Image Picker controller ViewController extension
extension AddEditCategoriesVC: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    //Launch image Picker
    func launchImagePicker() {
        let imagePickerVC = UIImagePickerController()
        imagePickerVC.delegate = self
        present(imagePickerVC, animated: true, completion: nil)
    }
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        
        guard let image = info[.originalImage] as? UIImage else {return}
        categoryImage.contentMode = .scaleAspectFit
        categoryImage.image = image
        dismiss(animated: true, completion: nil)
        
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        dismiss(animated: true, completion: nil)
    }
}
