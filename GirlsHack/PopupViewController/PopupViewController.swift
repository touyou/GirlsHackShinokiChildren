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
        
        dismiss(animated: true, completion: nil)
    }
}
