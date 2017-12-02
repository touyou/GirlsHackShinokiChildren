//
//  HomeViewController.swift
//  GirlsHack
//
//  Created by 藤井陽介 on 2017/12/02.
//  Copyright © 2017年 touyou. All rights reserved.
//

import UIKit

class HomeViewController: UIViewController {
    
    static var kAssocKeyWindow: String?

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        performSegue(withIdentifier: "popupNotification", sender: nil)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
//        AccountHelper.shared.logIn {}
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func tappedStampButton(_ sender: Any) {
        
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
    
    @IBAction func tappedSearchButton(_ sender: Any) {
        
        // TODO: searchへの遷移
    }
}
