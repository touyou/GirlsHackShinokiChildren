//
//  UIViewController+Extensions.swift
//  MusicAppClone
//
//  Created by 藤井陽介 on 2017/09/16.
//  Copyright © 2017年 藤井陽介. All rights reserved.
//

import UIKit

extension UIViewController {
    
    func hideBackButtonTitle() {
        
        let backBarButton = UIBarButtonItem()
        backBarButton.title = ""
        navigationItem.backBarButtonItem = backBarButton
    }
    
    func setCloseButton() {
        
        let closeButton = UIBarButtonItem(barButtonSystemItem: .stop, target: self, action: #selector(handleCloseButton(_:)))
        navigationItem.rightBarButtonItem = closeButton
    }
    
    func setLeftCloseButton() {
        
        let closeButton = UIBarButtonItem(barButtonSystemItem: .stop, target: self, action: #selector(handleCloseButton(_:)))
        navigationItem.leftBarButtonItem = closeButton
    }
    
    @objc func handleCloseButton(_ sender: UIBarButtonItem) {
        
        dismiss(animated: true, completion: nil)
    }
}
