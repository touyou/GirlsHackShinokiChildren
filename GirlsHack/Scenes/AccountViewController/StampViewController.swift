//
//  StampViewController.swift
//  GirlsHack
//
//  Created by 藤井陽介 on 2017/12/02.
//  Copyright © 2017年 touyou. All rights reserved.
//

import UIKit

class StampViewController: UIViewController {

    @IBOutlet weak var containerView: UIView! {
        
        didSet {
            
            pageViewController = StampPageViewController.instantiate()
            pageViewController.view.frame = containerView.bounds
            containerView.addSubview(pageViewController.view)
            self.addChildViewController(pageViewController)
        }
    }
    var pageViewController: StampPageViewController!
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    @IBAction func touchUpInsideExitButton(_ sender: Any) {
        
        let window = objc_getAssociatedObject(UIApplication.shared, &HomeViewController.kAssocKeyWindow) as! UIWindow
        
        UIView.transition(with: window, duration: 0.3, options: [.transitionCrossDissolve, .curveEaseIn], animations: {
            
            window.alpha = 0
        }, completion: { _ in
            
            window.rootViewController?.view.removeFromSuperview()
            window.rootViewController = nil
            objc_setAssociatedObject(UIApplication.shared, &HomeViewController.kAssocKeyWindow, nil, .OBJC_ASSOCIATION_RETAIN_NONATOMIC)
            
            guard let nextWindow = UIApplication.shared.delegate?.window as? UIWindow else {
                
                // TODO: Some window
                return
            }
            nextWindow.makeKeyAndVisible()
        })
    }
    
    @IBAction func touchUpInsideBackButton(_ sender: Any) {
        
        pageViewController.goBack()
    }
    
    @IBAction func touchUpInsideForwardButton(_ sender: Any) {
        
        pageViewController.goForward()
    }
}

// MARK: - Storyboard Instantiable

extension StampViewController: StoryboardInstantiable {}
