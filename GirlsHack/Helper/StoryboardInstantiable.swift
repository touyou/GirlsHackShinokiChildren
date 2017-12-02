//
//  StoryboardInstantiable.swift
//  MusicAppClone
//
//  Created by 藤井陽介 on 2017/09/15.
//  Copyright © 2017年 藤井陽介. All rights reserved.
//

import UIKit

// MARK: - Storyboard Instantiable

protocol StoryboardInstantiable: class {
    
    static var storyboardName: String { get }
}

extension StoryboardInstantiable where Self: UIViewController {
    
    static var storyboardName: String {
        
        return String(describing: self)
    }
    
    static func instantiate() -> Self {
        
        let storyboard = UIStoryboard(name: storyboardName, bundle: nil)
        
        guard let controller = storyboard.instantiateInitialViewController() as? Self else {
            
            assert(false, "生成したいViewControllerと同じ名前のStorybaordが見つからないか、Initial ViewControllerに設定されていない可能性があります。")
        }
        
        return controller
    }
}
