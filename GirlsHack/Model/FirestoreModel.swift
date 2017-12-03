//
//  FirestoreModel.swift
//  GirlsHack
//
//  Created by 藤井陽介 on 2017/12/03.
//  Copyright © 2017年 touyou. All rights reserved.
//

import Foundation

struct Post {
    
    var latitude: Double
    var longitude: Double
    var photoURL: String
    var message: String
    var userId: String
    var date: Date
    
    var dictionary: [String: Any] {
        
        return [
            "latitude": latitude,
            "longitude": longitude,
            "photoURL": photoURL,
            "message": message,
            "userId": userId,
            "date": date
        ]
    }
}

extension Post: DocumentSerializable {
    
    init?(dictionary: [String : Any]) {
        
        guard let latitude = dictionary["latitude"] as? Double,
            let longitude = dictionary["longitude"] as? Double,
            let photoURL = dictionary["photoURL"] as? String,
            let message = dictionary["message"] as? String,
            let userId = dictionary["userId"] as? String,
            let date = dictionary["date"] as? Date else { return nil }
        
        self.init(latitude: latitude, longitude: longitude, photoURL: photoURL, message: message, userId: userId, date: date)
    }
}

struct UserInfo {
    
    var name: String
    var iconURL: String
    
    var dictionary: [String: Any] {
        
        return [
            "name": name,
            "iconURL": iconURL
        ]
    }
}

extension UserInfo: DocumentSerializable {
    
    init?(dictionary: [String : Any]) {
        
        guard let name = dictionary["name"] as? String,
            let iconURL = dictionary["iconURL"] as? String else { return nil }
        
        self.init(name: name, iconURL: iconURL)
    }
}
