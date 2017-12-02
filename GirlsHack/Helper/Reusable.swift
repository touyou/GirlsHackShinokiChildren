//
//  Reusable.swift
//  MusicAppClone
//
//  Created by 藤井陽介 on 2017/09/15.
//  Copyright © 2017年 藤井陽介. All rights reserved.
//

import UIKit

// MARK: Reusable

protocol Reusable: class {
    
    static var defaultReuseIdentifier: String { get }
}

extension Reusable where Self: UIView {
    
    static var defaultReuseIdentifier: String {
        
        return String(describing: self)
    }
}
