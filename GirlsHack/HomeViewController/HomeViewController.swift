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

    override func viewDidLoad() {
        settings.style.buttonBarBackgroundColor = .white
        // ButtonBarItemの背景色
        settings.style.buttonBarItemBackgroundColor = UIColor(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0)
        // 選択中のButtonBarの下部の色
        settings.style.selectedBarBackgroundColor = .orange
        settings.style.buttonBarItemFont = .boldSystemFont(ofSize: 14)
        settings.style.selectedBarHeight = 2.0
        settings.style.buttonBarMinimumLineSpacing = 0
        settings.style.buttonBarItemTitleColor = .black
        settings.style.buttonBarItemsShouldFillAvailiableWidth = true
        settings.style.buttonBarLeftContentInset = 0
        settings.style.buttonBarRightContentInset = 0
        changeCurrentIndexProgressive = { [weak self] (oldCell: ButtonBarViewCell?, newCell: ButtonBarViewCell?, progressPercentage: CGFloat, changeCurrentIndex: Bool, animated: Bool) -> Void in
            guard changeCurrentIndex == true else { return }
            // 選択されていないボタンのテキスト色
            oldCell?.label.textColor = .black
            // 選択されているボタンのテキスト色
            newCell?.label.textColor = .yellow
        }

        super.viewDidLoad()

        // Do any additional setup after loading the view.
        performSegue(withIdentifier: "popupNotification", sender: nil)
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)

//        AccountHelper.shared.logIn {}
    }
    /// ViewControllers
    override func viewControllers(for pagerTabStripController: PagerTabStripViewController) -> [UIViewController] {

        // 追加したViewControllerを指定
        let firstVC = UIStoryboard(name: "HomeViewController", bundle: nil).instantiateViewController(withIdentifier: "HomeTimeLine")
        let secondVC = UIStoryboard(name: "HomeViewController", bundle: nil).instantiateViewController(withIdentifier: "HomeMap")

        // ViewControllersに入れる
        let childViewControllers:[UIViewController] = [firstVC, secondVC]
        return childViewControllers
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
