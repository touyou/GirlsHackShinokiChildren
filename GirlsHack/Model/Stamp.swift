//
//  Stamp.swift
//  GirlsHack
//
//  Created by 藤井陽介 on 2017/12/02.
//  Copyright © 2017年 touyou. All rights reserved.
//

import Foundation
import RealmSwift
import Realm

// MARK: - Stamp

class Stamp: Object {
    static let realm = try! Realm()
    
    @objc dynamic private var id = 0
    @objc dynamic private var _iconImage: UIImage? = nil
    @objc dynamic var iconImage: UIImage? {
        
        set {
            
            self._iconImage = newValue
            if let value = newValue {
                
                self.iconImageData = UIImagePNGRepresentation(value)
            }
        }
        get {
            
            if let image = self._iconImage {
                
                return image
            }
            if let data = self.iconImageData {
                
                self._iconImage = UIImage(data: data)
                return self._iconImage
            }
            return nil
        }
    }
    @objc dynamic private var iconImageData: Data? = nil
    @objc dynamic private var _photo: UIImage? = nil
    @objc dynamic var photo: UIImage? {
        
        set {
            
            self._photo = newValue
            if let value = newValue {
                
                self.photoData = UIImagePNGRepresentation(value)
            }
        }
        get {
            
            if let image = self._photo {
                
                return image
            }
            if let data = self.photoData {
                
                self._photo = UIImage(data: data)
                return self._photo
            }
            return nil
        }
    }
    @objc dynamic private var photoData: Data? = nil
    
    override static func primaryKey() -> String? {
        
        return "id"
    }
    
    override static func ignoredProperties() -> [String] {
        
        return ["_iconImage", "iconImage", "_photo", "photo"]
    }
    
    static func create() -> Stamp {
        
        let stamp = Stamp()
        stamp.id = lastId()
        return stamp
    }
    
    static func loadAll() -> [Stamp] {
        
        let stamps = realm.objects(Stamp.self).sorted(byKeyPath: "id", ascending: false)
        return stamps.map { $0 }
    }
    
    static func lastId() -> Int {
        
        if let stamp = realm.objects(Stamp.self).last {
            
            return stamp.id + 1
        } else {
            
            return 1
        }
    }
    
    func save() {
        
        try! Stamp.realm.write {
            
            Stamp.realm.add(self)
        }
    }
}

