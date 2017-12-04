//
//  HomeTimeLineViewController.swift
//  GirlsHack
//
//  Created by MiraiNIKI on 2017/12/02.
//  Copyright © 2017年 touyou. All rights reserved.
//

import UIKit
import XLPagerTabStrip


class HomeTimeLineViewController: UIViewController {

    @IBOutlet weak var collectionView: UICollectionView! {

        didSet {
            
            collectionView.dataSource = self
            collectionView.delegate = self
            collectionView.register(HomeTimeLineCollectionViewCell.self)
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()
    }
}

// MARK: - CollectionView Protocols

extension HomeTimeLineViewController: UICollectionViewDataSource {
    
    //データの個数を返すメソッド
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 10
    }
    
    //データを返すメソッド
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell: HomeTimeLineCollectionViewCell = collectionView.dequeueReusableCell(forIndexPath: indexPath)
        cell.backgroundColor = .white
        
        let imgArray = [UIImage(named: "timeline01.png"), UIImage(named: "timeline02.png")]
        //セルの画像を設定する
        cell.imageView.image = imgArray[indexPath.row % 2]
        
        return cell
    }
}

extension HomeTimeLineViewController: UICollectionViewDelegate {
    
    //セル選択時に呼び出されるメソッド
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {

        //詳細ページへ遷移
        let actView = ActivityViewController.instantiate()
        UIApplication.shared.topPresentedNavigationController?.pushViewController(actView, animated: true)
    }
}

extension HomeTimeLineViewController: UICollectionViewDelegateFlowLayout {

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {

        let cellWidth = floor(collectionView.bounds.width*9/10)

        return CGSize(width: cellWidth, height: cellWidth)
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {

        return floor(collectionView.bounds.width*1/20)
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {

        return 0
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {

        return UIEdgeInsets.zero
    }
}

// MARK: - XLPagerTabStrip

extension HomeTimeLineViewController: IndicatorInfoProvider {
    
    func indicatorInfo(for pagerTabStripController: PagerTabStripViewController) -> IndicatorInfo {
        
        let itemInfo: IndicatorInfo = IndicatorInfo (image: #imageLiteral(resourceName: "timeline icon"), highlightedImage: #imageLiteral(resourceName: "timeline icon_on"))
        return itemInfo
    }
}

// MARK: - Storyboard Instantiable

extension HomeTimeLineViewController: StoryboardInstantiable {}
