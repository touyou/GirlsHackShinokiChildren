//
//  UITabBarController+Extensions.swift
//  MusicAppClone
//
//  Created by 藤井陽介 on 2017/09/16.
//  Copyright © 2017年 藤井陽介. All rights reserved.
//

import UIKit

extension UITabBarController {
    
    func hideTabBar(_ hidden: Bool, duration: TimeInterval = 0.2) {
        
        UIView.beginAnimations(nil, context: nil)
        UIView.setAnimationDuration(duration)
        
        let views = view.subviews
        for view in views {
            
            var rect = view.frame
            let frame = tabBar.bounds
            let y = UIScreen.main.bounds.height - frame.height
            if view is UITabBar {
                
                rect.origin.y = hidden ? UIScreen.main.bounds.height : y
            } else {
                
                rect.size.height = hidden ? UIScreen.main.bounds.height : y
            }
            view.frame = rect
        }
        
        UIView.commitAnimations()
    }
}
