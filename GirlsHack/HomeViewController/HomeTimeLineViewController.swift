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

    @IBOutlet weak var collectionView: UICollectionView! {

        didSet {

            collectionView.dataSource = self

            collectionView.register(HomeTimeLineCollectionViewCell.self)
        }
    }
    // タブのタイトルを設定
    var itemInfo: IndicatorInfo = "TimeLine"

    //データの個数を返すメソッド
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int
    {
        return 10
    }

    //データを返すメソッド
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell
    {
        let cell: HomeTimeLineCollectionViewCell = collectionView.dequeueReusableCell(forIndexPath: indexPath)

        //セルの画像を設定する
        //cell.imageView.image = UIImage(named:"hoge.png")
        //影をつける
        cell.layer.masksToBounds = false; //必須
        cell.layer.shadowOffset = CGSize(width: 0.0, height: 2.0)
        cell.layer.shadowOpacity = 0.9;
        cell.layer.shadowRadius = 2.0;

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

extension HomeTimeLineViewController: UICollectionViewDelegateFlowLayout {

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {

        let cellWidth = floor(collectionView.bounds.width)

        return CGSize(width: cellWidth, height: cellWidth)
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {

        return 0
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {

        return 0
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {

        return UIEdgeInsets.zero
    }
}

extension HomeTimeLineViewController: StoryboardInstantiable {}
