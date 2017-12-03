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

    static let stampCountPerPage: Int = 12
    
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
        
        if currentStart + StampPageViewController.stampCountPerPage < stamps.count {
            
            currentStart += StampPageViewController.stampCountPerPage
            let viewController = StampCollectionViewController.instantiate()
            viewController.stamps = Array(stamps.dropFirst(currentStart).prefix(9))
            self.setViewControllers([viewController], direction: .forward, animated: true, completion: nil)
        }
    }
    
    func goBack() {
        
        if currentStart - StampPageViewController.stampCountPerPage >= 0 {
            
            currentStart -= StampPageViewController.stampCountPerPage
            let viewController = StampCollectionViewController.instantiate()
            viewController.stamps = Array(stamps.dropFirst(currentStart).prefix(9))
        }
    }
}

// MARK: - UIPageViewControllerDataSource

extension StampPageViewController: UIPageViewControllerDataSource {
    
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerAfter viewController: UIViewController) -> UIViewController? {
        
//        if currentStart + StampPageViewController.stampCountPerPage >= stamps.count {
//
//            return nil
//        }
        
        let viewController = StampCollectionViewController.instantiate()
        let afterStart = currentStart + StampPageViewController.stampCountPerPage
        viewController.stamps = Array(stamps.dropFirst(afterStart).prefix(9))
        return viewController
    }
    
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerBefore viewController: UIViewController) -> UIViewController? {
        
        if currentStart - StampPageViewController.stampCountPerPage < 0 {
            
            return nil
        }
        
        let viewController = StampCollectionViewController.instantiate()
        let beforeStart = currentStart - StampPageViewController.stampCountPerPage
        viewController.stamps = Array(stamps.dropFirst(beforeStart).prefix(9))
        return viewController
    }
}

// MARK: - Storyboard Instantiable

extension StampPageViewController: StoryboardInstantiable {}
