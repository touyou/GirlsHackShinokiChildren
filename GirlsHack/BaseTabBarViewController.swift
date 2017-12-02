//
//  BaseTabBarViewController.swift
//  GirlsHack
//
//  Created by 藤井陽介 on 2017/12/02.
//  Copyright © 2017年 touyou. All rights reserved.
//

import UIKit

class BaseTabBarViewController: UITabBarController {
    
    // MARK: - LifeCycle
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        setupBigCenterButton()
    }
    
    // MARK: - Private
    
    private func setupBigCenterButton() {
        
        let button = UIButton(type: .custom)
        button.setBackgroundImage(UIImage(named: ""), for: .normal)
        button.sizeToFit()
        button.center = CGPoint(x: tabBar.bounds.size.width / 2, y: tabBar.bounds.size.height - (button.bounds.size.height / 2))
        button.addTarget(self, action: #selector(tapBigCenter(_:)), for: .touchUpInside)
        tabBar.addSubview(button)
    }
    
    @objc private func tapBigCenter(_ sender: Any) {
        
        selectedIndex = 3
    }
}
