//
//  StampPageViewController.swift
//  GirlsHack
//
//  Created by 藤井陽介 on 2017/12/02.
//  Copyright © 2017年 touyou. All rights reserved.
//

import UIKit
import RealmSwift

class StampPageViewController: UIPageViewController {

    var stamps: [Stamp] = []
    var currentStart: Int = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        stamps = Stamp.loadAll()
        
        self.dataSource = self
        
        let viewController = StampCollectionViewController.instantiate()
        viewController.stamps = Array(stamps.prefix(9))
        self.setViewControllers([viewController], direction: .forward, animated: true, completion: nil)
    }
    
    func goForward() {
        
        if currentStart + 9 < stamps.count {
            
            currentStart += 9
            let viewController = StampCollectionViewController.instantiate()
            viewController.stamps = Array(stamps.dropFirst(currentStart).prefix(9))
            self.setViewControllers([viewController], direction: .forward, animated: true, completion: nil)
        }
    }
    
    func goBack() {
        
        if currentStart - 9 >= 0 {
            
            currentStart -= 9
            let viewController = StampCollectionViewController.instantiate()
            viewController.stamps = Array(stamps.dropFirst(currentStart).prefix(9))
        }
    }
}

// MARK: - UIPageViewControllerDataSource

extension StampPageViewController: UIPageViewControllerDataSource {
    
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerAfter viewController: UIViewController) -> UIViewController? {
        
        if currentStart + 9 >= stamps.count {
            
            return nil
        }
        
        let viewController = StampCollectionViewController.instantiate()
        let afterStart = currentStart + 9
        viewController.stamps = Array(stamps.dropFirst(afterStart).prefix(9))
        return viewController
    }
    
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerBefore viewController: UIViewController) -> UIViewController? {
        
        if currentStart - 9 < 0 {
            
            return nil
        }
        
        let viewController = StampCollectionViewController.instantiate()
        let beforeStart = currentStart - 9
        viewController.stamps = Array(stamps.dropFirst(beforeStart).prefix(9))
        return viewController
    }
}

// MARK: - Storyboard Instantiable

extension StampPageViewController: StoryboardInstantiable {}
