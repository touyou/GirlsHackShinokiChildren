//
//  AccountContentsViewController.swift
//  GirlsHack
//
//  Created by 藤井陽介 on 2017/12/03.
//  Copyright © 2017年 touyou. All rights reserved.
//

import UIKit
import XLPagerTabStrip

class AccountContentsViewController: ButtonBarPagerTabStripViewController {

    override func viewDidLoad() {

        settings.style.buttonBarBackgroundColor = UIColor.Original.background
        settings.style.buttonBarItemBackgroundColor = UIColor.Original.background
        settings.style.selectedBarBackgroundColor = .darkGray
        settings.style.buttonBarItemFont = .boldSystemFont(ofSize: 14)
        settings.style.selectedBarHeight = 2.0
        settings.style.buttonBarMinimumLineSpacing = 0
        settings.style.buttonBarItemTitleColor = .darkGray
        settings.style.buttonBarItemsShouldFillAvailableWidth = true
        settings.style.buttonBarLeftContentInset = 0
        settings.style.buttonBarRightContentInset = 0
        changeCurrentIndexProgressive = { (oldCell: ButtonBarViewCell?, newCell: ButtonBarViewCell?, progressPercentage: CGFloat, changeCurrentIndex: Bool, animated: Bool) -> Void in
            
//            guard let `self` = self else { return }
            guard changeCurrentIndex == true else { return }
            // 選択されていないボタンのテキスト色
            oldCell?.label.textColor = .lightGray
            // 選択されているボタンのテキスト色
            newCell?.label.textColor = .darkGray
        }
        
        super.viewDidLoad()
    }
    
    // MARK: XLPaagerTabStrip
    
    override func viewControllers(for pagerTabStripController: PagerTabStripViewController) -> [UIViewController] {
        
        let viewController = AccountTimelineViewController.instantiate()
        let viewController2 = AccountTimelineViewController.instantiate()
        
        viewController.titleStr = "自分のフィード"
        viewController2.titleStr = "あとで見る"
        
        return [viewController, viewController2]
    }
}

// MARK: - Storyboard Instantiable

extension AccountContentsViewController: StoryboardInstantiable {}
