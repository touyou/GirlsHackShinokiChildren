//
//  PopupViewController.swift
//  GirlsHack
//
//  Created by 藤井陽介 on 2017/12/02.
//  Copyright © 2017年 touyou. All rights reserved.
//

import UIKit

class PopupViewController: UIViewController {

    @IBOutlet weak var messageLabel: UILabel! {
        
        didSet {
            
            messageLabel.text = message[Int(arc4random_uniform(UInt32(message.count)))]
        }
    }
    
    let message: [String] = ["おはよう！", "今日も起きれたね👍"]
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    
    @IBAction func touchUpInsideButton(_ sender: Any) {
        
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
}

// MARK: - Storyboard Instantiable

extension PopupViewController: StoryboardInstantiable {}
