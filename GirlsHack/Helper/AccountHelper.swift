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
        
    }
}

class AccountHelper {
    
    static let shared = AccountHelper()
    let cache = UserDefaults.standard
    let defaultStore: Firestore!
    
    private var userId: String?
    private var ref: DocumentReference?
    
    private init() {
        
        if let id = cache.object(forKey: "userId") as? String {
            
            userId = id
        }
        
        defaultStore = Firestore.firestore()
    }
    
    internal var isLogIn: Bool {
        
        return userId != nil
    }
    
    internal func logIn(_ completion: ()->()) {
        
        userId = UIDevice.current.identifierForVendor?.uuidString
        completion()
    }
}
