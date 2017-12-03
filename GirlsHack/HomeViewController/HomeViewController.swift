//
//  HomeViewController.swift
//  GirlsHack
//
//  Created by 藤井陽介 on 2017/12/02.
//  Copyright © 2017年 touyou. All rights reserved.
//

import UIKit
import XLPagerTabStrip

class HomeViewController: ButtonBarPagerTabStripViewController {

    static var kAssocKeyWindow: String?

    @IBOutlet weak var accountButton: UIBarButtonItem!
    @IBOutlet weak var searchButton: UIBarButtonItem!
    
    override func viewDidLoad() {
        
        settings.style.buttonBarBackgroundColor = UIColor(white: 1.0, alpha: 0.3)
        // ButtonBarItemの背景色
        settings.style.buttonBarItemBackgroundColor = UIColor(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0)
        // 選択中のButtonBarの下部の色
        settings.style.selectedBarBackgroundColor = .white
        settings.style.buttonBarItemFont = .boldSystemFont(ofSize: 14)
        settings.style.selectedBarHeight = 0.0
        settings.style.buttonBarMinimumLineSpacing = 0
        settings.style.buttonBarItemTitleColor = .black
        settings.style.buttonBarItemsShouldFillAvailiableWidth = true
        settings.style.buttonBarLeftContentInset = self.view.bounds.width/2 - self.view.bounds.width/6
        settings.style.buttonBarRightContentInset = self.view.bounds.width/2 - self.view.bounds.width/6
        settings.style.buttonBarMinimumLineSpacing = self.view.bounds.width/10
//        changeCurrentIndex = { [weak self] (oldCell: ButtonBarViewCell?, newCell: ButtonBarViewCell?, animated: Bool) -> Void in
//
//            guard let `self` = self else { return }
//            // ボタン画像の比率
//            oldCell?.imageView.contentMode = UIViewContentMode.scaleAspectFit
//            newCell?.imageView.contentMode = UIViewContentMode.scaleAspectFit
//
//            //レンダリングモードをAlwayOriginalにして画像を読み込む。
//            let image = UIImage(named: "menuicon_navbar")!.withRenderingMode(.alwaysOriginal)
//            let image02 = UIImage(named: "searchicon_navbar")!.withRenderingMode(.alwaysOriginal)
//            s
//            self.accountButton.image = image
//            self.searchButton.image = image02
//        }
        changeCurrentIndexProgressive = { [weak self] (oldCell: ButtonBarViewCell?, newCell: ButtonBarViewCell?, progressPercentage: CGFloat, changeCurrentIndex: Bool, animated: Bool) -> Void in
            
            guard let `self` = self else { return }
            guard changeCurrentIndex == true else { return }
            // ボタン画像の比率
            oldCell?.imageView.contentMode = UIViewContentMode.scaleAspectFit
            newCell?.imageView.contentMode = UIViewContentMode.scaleAspectFit
            
            //レンダリングモードをAlwayOriginalにして画像を読み込む。
            let image = UIImage(named: "menuicon_navbar")!.withRenderingMode(.alwaysOriginal)
            let image02 = UIImage(named: "searchicon_navbar")!.withRenderingMode(.alwaysOriginal)
            
            self.accountButton.image = image
            self.searchButton.image = image02
        }

        super.viewDidLoad()

        // Do any additional setup after loading the view.
//        performSegue(withIdentifier: "popupNotification", sender: nil)
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)

//        AccountHelper.shared.logIn {}
    }
    
    /// ViewControllers
    override func viewControllers(for pagerTabStripController: PagerTabStripViewController) -> [UIViewController] {

        // 追加したViewControllerを指定
        let firstVC = HomeTimeLineViewController.instantiate()
        let secondVC = HomeMapViewController.instantiate()

        // ViewControllersに入れる
        let childViewControllers:[UIViewController] = [firstVC, secondVC]
        return childViewControllers
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    @IBAction func touchUpInsideEdit(_ sender: Any) {
        
        let editViewController = EditViewController.instantiate()
        let navi = UINavigationController(rootViewController: editViewController)
        present(navi, animated: true, completion: nil)
    }
    
    @IBAction func tappedStampButton(_ sender: Any) {

        performSegue(withIdentifier: "toAccountView", sender: nil)
    }

    @IBAction func tappedSearchButton(_ sender: Any) {

        performSegue(withIdentifier: "toSearchView", sender: nil)
    }
}
