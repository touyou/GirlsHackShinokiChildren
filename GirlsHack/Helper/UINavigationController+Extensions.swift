//
//  UINavigationController+Extensions.swift
//  MusicAppClone
//
//  Created by 藤井陽介 on 2017/09/16.
//  Copyright © 2017年 藤井陽介. All rights reserved.
//

import UIKit

extension UINavigationController {
    
    var isTranslucent: Bool {
        get {
            
            return navigationBar.isTranslucent
        }
        set {
            
            let image = newValue ? UIImage() : nil
            navigationBar.setBackgroundImage(image, for: .default)
            navigationBar.shadowImage = image
            navigationBar.isTranslucent = newValue
        }
    }
}
