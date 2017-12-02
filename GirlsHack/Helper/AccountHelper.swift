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
import CoreLocation

struct Post {
    
    var latitude: Double
    var longitude: Double
    var photo: UIImage
    var message: String
    var userId: String
    var date: Date
    
    var dictionary: [String: Any] {
        
        return [
            "latitude": latitude,
            "longitude": longitude,
            "photo": photo,
            "message": message,
            "userId": userId,
            "date": date]
    }
}

extension Post: DocumentSerializable {
    
    init?(dictionary: [String : Any]) {
        
        guard let latitude = dictionary["latitude"] as? Double,
            let longitude = dictionary["longitude"] as? Double,
            let photo = dictionary["photo"] as? UIImage,
            let message = dictionary["message"] as? String,
            let userId = dictionary["userId"] as? String,
            let date = dictionary["date"] as? Date else { return nil }
        
        self.init(latitude: latitude, longitude: longitude, photo: photo, message: message, userId: userId, date: date)
    }
}

class AccountHelper {
    
    static let shared = AccountHelper()
    let cache = UserDefaults.standard
    let defaultStore: Firestore!
    
    private var userId: String?
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
    
    var iconImage: UIImage?
    var userName: String?
    var posts: [Post] = []
    
    private init() {
        
        if let id = cache.object(forKey: "userId") as? String {
            
            userId = id
        }
        
        defaultStore = Firestore.firestore()
        query = fetchQuery(for: "posts")
    }
    
    deinit {
        
        listener?.remove()
    }
    
    internal var isLogIn: Bool {
        
        return userId != nil
    }
    
    internal func logIn(_ completion: @escaping ()->()) {
        
        userId = UIDevice.current.identifierForVendor?.uuidString
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
    
    internal func fetchQuery(for key: String) -> Query {
        
        return defaultStore.collection(key).limit(to: 50)
    }
    
    internal func postData(location: CLLocation, photo: UIImage, message: String) {
        
        guard let user = Auth.auth().currentUser else {
            return
        }
        
        let batch = defaultStore.batch()
        let post = Post(latitude: location.coordinate.latitude, longitude: location.coordinate.longitude, photo: photo, message: message, userId: user.uid, date: Date())
        let ref = defaultStore.collection("posts").document()
        batch.setData(post.dictionary, forDocument: ref)
        batch.commit { error in
            
            guard let error = error else { return }
            print("commit error: \(error.localizedDescription)")
        }
    }
}
