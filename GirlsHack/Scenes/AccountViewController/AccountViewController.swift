//
//  AccountViewController.swift
//  GirlsHack
//
//  Created by 藤井陽介 on 2017/12/02.
//  Copyright © 2017年 touyou. All rights reserved.
//

import UIKit

class AccountViewController: UIViewController {
    
    @IBOutlet weak var iconImageView: UIImageView! {
        
        didSet {
            
            iconImageView.cornerRadius = iconImageView.bounds.width / 2
        }
    }
    @IBOutlet weak var containerView: UIView! {
        
        didSet {
            
            let viewController = AccountContentsViewController.instantiate()
            viewController.view.frame = containerView.bounds
            containerView.addSubview(viewController.view)
            addChildViewController(viewController)
        }
    }
    @IBOutlet weak var barButton: UIBarButtonItem! {
        
        didSet {
            
            let image = UIImage(named: "stampcard")!.withRenderingMode(.alwaysOriginal)
            barButton.image = image
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    @IBAction func touchUpInsideStampButton(_ sender: Any) {
        
        let newWindow = UIWindow()
        newWindow.frame = UIScreen.main.bounds
        newWindow.alpha = 0.0
        newWindow.rootViewController = StampViewController.instantiate()
        newWindow.backgroundColor = UIColor(white: 0, alpha: 0.6)
        newWindow.windowLevel = UIWindowLevelNormal + 5
        newWindow.makeKeyAndVisible()

        objc_setAssociatedObject(UIApplication.shared, &HomeViewController.kAssocKeyWindow, newWindow, .OBJC_ASSOCIATION_RETAIN_NONATOMIC)

        UIView.transition(with: newWindow, duration: 0.2, options: [.transitionCrossDissolve, .curveEaseIn], animations: {

            newWindow.alpha = 1.0
        }, completion: { finished in})
    }
}
