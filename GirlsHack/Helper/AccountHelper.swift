//
//  AccountHelper.swift
//  GirlsHack
//
//  Created by 藤井陽介 on 2017/12/02.
//  Copyright © 2017年 touyou. All rights reserved.
//

import Foundation
import Firebase
import CoreLocation

struct Object {
    
    var location: CLLocation
    var photo: UIImage
    var message: String
    var userId: String
    var date: Date
    
    func createDictionary() -> [String: Any] {
        
        return ["location": location, "photo": photo, "message": message, "userId": userId, "date": date]
    }
}

class AccountHelper {
    
    static let shared = AccountHelper()
    let cache = UserDefaults.standard
    let defaultStore: Firestore!
    
    private var userId: String?
    private var ref: DocumentReference?
    
    var iconImage: UIImage?
    var userName: String?
    
    private init() {
        
        if let id = cache.object(forKey: "userId") as? String {
            
            userId = id
        }
        
        defaultStore = Firestore.firestore()
    }
    
    internal var isLogIn: Bool {
        
        return userId != nil
    }
    
    internal func logIn(_ completion: @escaping ()->()) {
        
        userId = UIDevice.current.identifierForVendor?.uuidString
        defaultStore.collection("users/\(userId!)").getDocuments() { [weak self] (querySnapshot, err) in
            
            guard let `self` = self else {
                
                return
            }
            
            if let err = err {
                
                print("Error: \(err.localizedDescription)")
            } else {
                
                guard let data = querySnapshot?.documents.first else {
                    
                    print("Not Found")
                    return
                }
                self.iconImage = data["icon_image"] as? UIImage
                self.userName = data["user_name"] as? String
                completion()
            }
        }
    }
}
