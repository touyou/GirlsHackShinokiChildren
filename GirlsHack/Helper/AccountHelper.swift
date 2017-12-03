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

protocol AccountHelperDelegate: class {
    
    func updateTimeline(_ posts: [Post])
}

/// MARK: - Account Helper
/// Usage:
///  - シングルトンになっているのでAccountHelper.sharedで読んであげる
///  - ログインはlogInで行える。Delegateはシングルトン自身
///  - 最初はなんのデータも持っていない
///  - ログインをした後、データが50件フェッチされuserInfoにユーザーの情報が格納される
///  - タイムラインは自動更新、自分の投稿したものはfetchQueryで明示的に呼んであげる
///  - ソートする場合はsortedQueryを使う
class AccountHelper: NSObject {
    
    static let shared = AccountHelper()
    let cache = UserDefaults.standard
    let defaultStore: Firestore!

    private var ref: DocumentReference?
    private var listener: ListenerRegistration?
    /// Timeline query
    internal var query: Query? {
        
        didSet {
            
            if let listener = listener {
                
                listener.remove()
                observeQuery()
            }
        }
    }
    
    /// Account Helper Delegate
    weak var delegate: AccountHelperDelegate?
    /// Timeline
    var posts: [Post] = []
    /// Current user name and icon
    var userInfo: UserInfo?
    
    private override init() {
        
        self.defaultStore = Firestore.firestore()
        super.init()
    }
    
    deinit {
        
        listener?.remove()
    }
    
    /// Judge log in
    internal var isLogIn: Bool {
        
        return Auth.auth().currentUser != nil
    }
    
    /// Login interface
    internal func logIn() {
        
        guard let auth = FUIAuth.defaultAuthUI() else {
            
            print("Auth Error")
            return
        }
        
        auth.delegate = self
        
        if auth.auth?.currentUser == nil {
            
            auth.providers = []
            UIApplication.shared.topPresentedViewController?.present(auth.authViewController(), animated: true, completion: nil)
            return
        }
    }
    
    /// Start query observing
    internal func observeQuery() {
        guard let query = query else { return }
        stopObserving()
        
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
            self.delegate?.updateTimeline(self.posts)
        }
    }
    
    /// Stop query observing
    internal func stopObserving() {
        
        listener?.remove()
    }
    
    /// Fetch Query for key and limit
    internal func fetchQuery(for key: String, limit: Int? = nil) -> Query {
        
        guard let limit = limit else {
            
            return defaultStore.collection(key)
        }
        
        return defaultStore.collection(key).limit(to: limit)
    }
    
    /// Post Data
    /// Arguments: location and photo, message, and completion
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
                
                guard let error = error else {
                    
                    completion()
                    return
                }
                print("commit error: \(error.localizedDescription)")
            }
        }
    }
    
    /// Sort collection query by key
    internal func sortedQuery(by key: String, for collection: String) -> Query {
        
        return fetchQuery(for: collection).order(by: key)
    }
    
    /// Loading User Information
    internal func loadUser() {
        
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
                self.userInfo = UserInfo(dictionary: data)
            }
            
        }
    }
}

extension AccountHelper: FUIAuthDelegate {
    
    func authUI(_ authUI: FUIAuth, didSignInWith user: User?, error: Error?) {
        
        guard let user = user else {
            
            print("Auth User Not Found")
            return
        }
        
        self.userInfo = UserInfo(name: user.displayName ?? "MAGirl_\(user.uid)", iconURL: "")
        self.defaultStore.collection("users").document(user.uid).setData(self.userInfo?.dictionary ?? [:], completion: { err in
            
            guard let err = err else {
                
                self.query = self.fetchQuery(for: "posts", limit: 50)
                return
            }
            print("Auth error: \(err.localizedDescription)")
        })
    }
    
    // TODO: - ブランドデザインにあわせたい
    
//    /// ログイン方法の選択？
//    func authPickerViewController(forAuthUI authUI: FUIAuth) -> FUIAuthPickerViewController {
//        return ViewController()
//    }
//
//    /// メールアドレスだけで入る画面
//    func emailEntryViewController(forAuthUI authUI: FUIAuth) -> FUIEmailEntryViewController {
//        return ViewController()
//    }
//
//    /// パスワードを入れてサインインするとこ
//    func passwordSignInViewController(forAuthUI authUI: FUIAuth, email: String) -> FUIPasswordSignInViewController {
//        return ViewController()
//    }
//
//    /// パスワードを入れてサインアップするとこ
//    func passwordSignUpViewController(forAuthUI authUI: FUIAuth, email: String) -> FUIPasswordSignUpViewController {
//        return ViewController()
//    }
//
//    /// パスワードを忘れた時
//    func passwordRecoveryViewController(forAuthUI authUI: FUIAuth, email: String) -> FUIPasswordRecoveryViewController {
//        return ViewController()
//    }
//
//    /// 確認
//    func passwordVerificationViewController(forAuthUI authUI: FUIAuth, email: String, newCredential: AuthCredential) -> FUIPasswordVerificationViewController {
//        return ViewController()
//    }
}
