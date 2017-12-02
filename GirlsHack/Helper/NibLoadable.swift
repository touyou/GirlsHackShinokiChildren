//
//  NibLoadable.swift
//  MusicAppClone
//
//  Created by 藤井陽介 on 2017/09/15.
//  Copyright © 2017年 藤井陽介. All rights reserved.
//

import UIKit

// MARK: - Nib Loadable

protocol NibLoadable: class {
    
    static var nibName: String { get }
}

extension NibLoadable where Self: UIView {
    
    static var nibName: String {
        
        return String(describing: self)
    }
}
