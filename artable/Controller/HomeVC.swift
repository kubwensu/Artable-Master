//
//  ViewController.swift
//  artable
//
//  Created by Kubwensu mambwe on 2019/12/15.
//  Copyright © 2019 Kubwensu mambwe. All rights reserved.
//

import UIKit
import Firebase

class HomeVC: UIViewController {
    //Outlets
    @IBOutlet weak var logInOutButton: UIBarButtonItem!
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    @IBOutlet weak var collectionView: UICollectionView!
    
    var categories = [Category]()
    var selectedCategory : Category!
    var listener : ListenerRegistration!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        collectionView.register( UINib(nibName: "CategoryCell", bundle: nil), forCellWithReuseIdentifier: "CategoryCell")
        if Auth.auth().currentUser == nil {
            Auth.auth().signInAnonymously { (result, Error) in
                if let error =  Error {
                    Auth.auth().handleFireAuthError(error: error, vc:self)
                    debugPrint(error)
                }
            }
        }
        
        
        // Do any additional setup after loading the view.
        
        //        fetchDocument()
        //                fetchCollection()
    }
    
    @IBAction func favoritesClicked(_ sender: Any) {
        performSegue(withIdentifier: "toFavorites", sender: self)
    }
    
    //MARK:- Fetching a single document
    //    func fetchDocument() {
    //        let docRef = Firestore.firestore().collection("categories").document("GdLqusKg20YVb0UOIy1U")
    //
    //        listener = docRef.addSnapshotListener { (snap, error) in
    //            self.categories.removeAll()
    //            guard let data = snap?.data() else {return}
    //            let newItem = Category.init(data: data)
    //            self.categories.append(newItem)
    //            self.collectionView.reloadData()
    //        }
    //        //
    //        //        docRef.getDocument { (snap, error) in
    //        //            guard let data = snap?.data() else {return}
    //        //            let newItem = Category.init(data: data)
    //        //            self.categories.append(newItem)
    //        //            self.collectionView.reloadData()
    //        //        }
    //    }
    //
    //MARK:- Fetching multiple documents
    //
    //    func fetchCollection() {
    //        let collection = Firestore.firestore().collection("categories")
    //
    //        //Adding snapshot listeners
    //        listener = collection.addSnapshotListener { (snap, error) in
    //            self.categories.removeAll()
    //            guard let documents = snap?.documents else {return}
    //            for document in documents {
    //                let data = document.data()
    //                let newItem = Category.init(data: data)
    //                self.categories.append(newItem)
    //            }
    //            self.collectionView.reloadData()
    //        }
    //
    //        //Fetching the documents
    //        //        collection.getDocuments { (snap, error) in
    //        //            guard let documents = snap?.documents else {return}
    //        //            for document in documents {
    //        //                let data = document.data()
    //        //                let newItem = Category.init(data: data)
    //        //                self.categories.append(newItem)
    //        //            }
    //        //            self.collectionView.reloadData()
    //        //
    //        //        }
    //    }
    
    //MARK:- Methods executed each time view appears
    
    override func viewDidAppear(_ animated: Bool) {
        //                  fetchDocument()
        //                fetchCollection()
        setCategoriesListener()
        if let user = Auth.auth().currentUser, !user.isAnonymous  {
            //We are logged in
            logInOutButton.title = "Logout"
            if UserService.userListener == nil {
                UserService.getCurrentUser()
            }
        }else{
            logInOutButton.title = "Login"
        }
    }
    
    //MARK:- Methods executed each time view dissappears
    
    override func viewDidDisappear(_ animated: Bool) {
        listener.remove()
        categories.removeAll()
        collectionView.reloadData()
    }
    
    //MARK:- Final function for calling fetching categories
    
    func setCategoriesListener() {
        listener = Firestore.firestore().collection("categories").order(by: "timestamp").addSnapshotListener({ (snap, error) in
            
            
            if let error = error {
                debugPrint(error.localizedDescription)
            }
            
            snap?.documentChanges.forEach({ (change) in
                let data = change.document.data()
                let category = Category.init(data: data)
                
                switch change.type {
                case .added:
                    self.documentAdded(change: change, category: category)
                case .modified:
                    self.documentModified(change: change, category: category)
                case .removed:
                    self.documentRemoved(change: change)
                }
            })
        })
    }
    
    func documentAdded(change: DocumentChange, category: Category) {
        let newIndex = Int(change.newIndex)
        categories.insert(category, at: newIndex)
        collectionView.insertItems(at: [IndexPath(item: newIndex, section: 0)])
        
    }
    
    func documentModified(change: DocumentChange, category: Category) {
        if change.newIndex == change.oldIndex {
            //changed properties but not position
            let index = Int(change.oldIndex)
            categories[index] = category
            collectionView.reloadItems(at: [IndexPath(item: index, section: 0)])
        }
        //changed value and position
        let newIndex = Int(change.oldIndex)
        let oldIndex = Int(change.oldIndex)
        categories.remove(at: oldIndex)  
        categories.insert(category, at: newIndex)
        collectionView.moveItem(at: IndexPath(item: oldIndex, section: 0), to: IndexPath(item: newIndex, section: 0))
    }
    
    func documentRemoved(change: DocumentChange){
        let oldIndex = Int(change.oldIndex)
        categories.remove(at: oldIndex)
        collectionView.deleteItems(at: [IndexPath(item: oldIndex, section: 0)])
        
    }
    
    fileprivate func presentViewController() {
        let storyboard = UIStoryboard(name: "LoginStoryBoard", bundle: nil)
        let controller = storyboard.instantiateViewController(identifier: "LoginVC")
        present(controller, animated: true, completion: nil)
    }
    
    @IBAction func logInOutClicked(_ sender: Any) {
        //MARK:- signing out and logging back into anonymous state
        
        guard let authUser = Auth.auth().currentUser else {return}
        
        if authUser.isAnonymous {
            presentViewController()
        }else{
            do{
                try Auth.auth().signOut()
                UserService.logOutUser()
                Auth.auth().signInAnonymously { (response, Error) in
                    if let error = Error {
                        Auth.auth().handleFireAuthError(error: error, vc:self)
                        debugPrint(error)
                        return
                    }
                    self.presentViewController()
                }
            } catch{
                Auth.auth().handleFireAuthError(error: error, vc:self)
                debugPrint(error)
            }
        }
        
        //MARK:- Logging out or in without anonymous state
        //        if let user = Auth.auth().currentUser  {
        //            //we are logged in
        //            do{
        //                try  Auth.auth().signOut()
        //                presentViewController()
        //            }catch{
        //                debugPrint(error.localizedDescription)
        //            }
        //         }else{
        //            presentViewController()
        //        }
        
    }
    
}

extension HomeVC: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout{
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return categories.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "CategoryCell", for: indexPath) as? CategoryCollectionViewCell {
            cell.configureCell(category: categories[indexPath.item])
            return cell
        }
        return UICollectionViewCell()
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let width = view.frame.width
        let cellWidth = (width - 50) / 2
        let cellHeight = cellWidth * 1.5
        
        return CGSize(width: cellWidth, height: cellHeight)
        
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        selectedCategory = categories[indexPath.item]
        performSegue(withIdentifier: "toProducts", sender: self)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "toProducts" {
            if let destination = segue.destination as? ProductsVC {
                destination.category = selectedCategory
            }else if segue.identifier == "toFavorites"{
                if let destination = segue.destination as? ProductsVC{
                    destination.category = selectedCategory
                    destination.showFavorites = true
                }
            }
        }
    }
}


