//
//  AccountHelper.swift
//  GirlsHack
//
//  Created by 藤井陽介 on 2017/12/02.
//  Copyright © 2017年 touyou. All rights reserved.
//

import Foundation
import Firebase
import FirebaseAuthUI
import FirebaseFirestore
import FirebaseStorage
import CoreLocation

class AccountHelper {
    
    static let shared = AccountHelper()
    let cache = UserDefaults.standard
    let defaultStore: Firestore!

    private var ref: DocumentReference?
    private var listener: ListenerRegistration?
    internal var query: Query? {
        
        didSet {
            
            if let listener = listener {
                
                listener.remove()
                observeQuery()
            }
        }
    }
    
    var posts: [Post] = []
    var userInfo: User?
    
    func loadUser() {
        
        guard let user = Auth.auth().currentUser else {
            
            return
        }
        
        defaultStore.collection("users").document(user.uid).getDocument { snapshot, err in
            
            if let err = err {
                
                print("load user error: \(err.localizedDescription)")
            } else {
                
                guard let data = snapshot?.data() else {
                    
                    return
                }
                self.userInfo = User(dictionary: data)
            }
            
        }
    }
    
    private init() {
        
        defaultStore = Firestore.firestore()
        query = fetchQuery(for: "posts")
    }
    
    deinit {
        
        listener?.remove()
    }
    
    internal var isLogIn: Bool {
        
        return Auth.auth().currentUser != nil
    }
    
    internal func logIn(_ completion: @escaping ()->()) {
        
        guard let auth = FUIAuth.defaultAuthUI() else {
            
            print("Auth Error")
            return
        }
        if auth.auth?.currentUser == nil {
            
            auth.providers = []
            UIApplication.shared.topPresentedViewController?.present(auth.authViewController(), animated: true, completion: nil)
        }
        
        completion()
    }
    
    internal func observeQuery() {
        guard let query = query else { return }
        stopObserving()
        
        // Display data from Firestore, part one
        
        listener = query.addSnapshotListener { [unowned self] (snapshot, error) in
            guard let snapshot = snapshot else {
                print("Error fetching snapshot results: \(error!)")
                return
            }
            let models = snapshot.documents.map { (document) -> Post in
                if let model = Post(dictionary: document.data()) {
                    return model
                } else {
                    // Don't use fatalError here in a real app.
                    fatalError("Unable to initialize type \(Post.self) with dictionary \(document.data())")
                }
            }
            
            self.posts = models
            
//            self.documents = snapshot.documents
//
//            if self.documents.count > 0 {
//                self.tableView.backgroundView = nil
//            } else {
//                self.tableView.backgroundView = self.backgroundView
//            }
//
//            self.tableView.reloadData()
        }
    }
    
    internal func stopObserving() {
        listener?.remove()
    }
    
    internal func fetchQuery(for key: String, limit: Int? = nil) -> Query {
        
        guard let limit = limit else {
            
            return defaultStore.collection(key)
        }
        
        return defaultStore.collection(key).limit(to: limit)
    }
    
    internal func postData(location: CLLocation, photo: UIImage, message: String, completion: @escaping ()->()) {
        
        guard let user = Auth.auth().currentUser else {
            return
        }
        
        var imageCount: Int
        if let count = cache.object(forKey: "imageCount") as? Int {
            
            imageCount = count + 1
        } else {
            
            imageCount = 0
        }
        cache.set(imageCount, forKey: "imageCount")
        let imageRef = Storage.storage().reference().child("images/\(user.uid)_\(imageCount).png")
        let _ = imageRef.putData(UIImagePNGRepresentation(photo)!, metadata: nil) { [weak self] metadata, error in
            
            guard let `self` = self else { return }
            guard let metadata = metadata else { return }
            
            let downloadURL = metadata.downloadURL()
            let batch = self.defaultStore.batch()
            let post = Post(latitude: location.coordinate.latitude, longitude: location.coordinate.longitude, photoURL: (downloadURL?.absoluteString)!, message: message, userId: user.uid, date: Date())
            let userRef = self.defaultStore.collection("users").document(user.uid).collection("posts").document()
            let ref = self.defaultStore.collection("posts").document()
            batch.setData(post.dictionary, forDocument: userRef)
            batch.setData(post.dictionary, forDocument: ref)
            
            batch.commit { error in
                
                completion()
                guard let error = error else { return }
                print("commit error: \(error.localizedDescription)")
            }
        }
    }
    
    internal func sortedQuery(by key: String) -> Query {
        
        return fetchQuery(for: "posts").order(by: key)
    }
}
