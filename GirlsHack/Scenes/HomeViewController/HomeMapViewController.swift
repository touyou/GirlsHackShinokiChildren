//
//  HomeMapViewController.swift
//  GirlsHack
//
//  Created by MiraiNIKI on 2017/12/02.
//  Copyright © 2017年 touyou. All rights reserved.
//

import UIKit
import XLPagerTabStrip

class HomeMapViewController: UIViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
}

// MARK: - XLPagerTabStrip

extension HomeMapViewController: IndicatorInfoProvider {
    
    func indicatorInfo(for pagerTabStripController: PagerTabStripViewController) -> IndicatorInfo {
        
        let itemInfo = IndicatorInfo(image: #imageLiteral(resourceName: "map icon_off"), highlightedImage: #imageLiteral(resourceName: "map icon"))
        return itemInfo
    }
}

// MARK: - Storyboard Instantiable

extension HomeMapViewController: StoryboardInstantiable {}
