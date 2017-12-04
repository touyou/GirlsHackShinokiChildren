//
//  UIApplication+Extensions.swift
//  MusicAppClone
//
//  Created by 藤井陽介 on 2017/09/16.
//  Copyright © 2017年 藤井陽介. All rights reserved.
//

import UIKit

extension UIApplication {
    
    var topPresentedViewController: UIViewController? {
        
        guard var topViewController = UIApplication.shared.keyWindow?.rootViewController else { return nil }
        
        while let presentedViewController = topViewController.presentedViewController {
            
            topViewController = presentedViewController
        }
        return topViewController
    }
    
    var topPresentedNavigationController: UINavigationController? {
        
        return topPresentedViewController as? UINavigationController
    }
}
