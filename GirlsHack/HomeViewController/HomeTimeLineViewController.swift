//
//  HomeTimeLineViewController.swift
//  GirlsHack
//
//  Created by MiraiNIKI on 2017/12/02.
//  Copyright © 2017年 touyou. All rights reserved.
//

import UIKit
import XLPagerTabStrip


class HomeTimeLineViewController: UIViewController, IndicatorInfoProvider, UICollectionViewDataSource {

    // タブのタイトルを設定
    var itemInfo: IndicatorInfo = "TimeLine"

    //データの個数を返すメソッド
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int
    {
        return 100
    }

    //データを返すメソッド
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell
    {
        //コレクションビューから識別子「CafeCell」のセルを取得する。
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "CafeCell", for: indexPath as IndexPath) as UICollectionViewCell

        //セルの背景色をランダムに設定する。
        cell.backgroundColor = UIColor(red: 0.5,
                                       green: 0.5,
                                       blue: 0,
                                       alpha: 1.0)
        return cell
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    func indicatorInfo(for pagerTabStripController: PagerTabStripViewController) -> IndicatorInfo {
        return itemInfo
    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}

extension HomeTimeLineViewController: StoryboardInstantiable {}
