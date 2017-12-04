//
//  AccountTimelineViewController.swift
//  GirlsHack
//
//  Created by 藤井陽介 on 2017/12/03.
//  Copyright © 2017年 touyou. All rights reserved.
//

import UIKit
import XLPagerTabStrip

class AccountTimelineViewController: UIViewController {

    @IBOutlet weak var collectionView: UICollectionView! {
        
        didSet {
            
            collectionView.dataSource = self
            collectionView.delegate = self
            
            collectionView.register(HomeTimeLineCollectionViewCell.self)
        }
    }
    var titleStr: String!
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    
}

// MARK: - Collection View Protocols

extension AccountTimelineViewController: UICollectionViewDataSource {
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        
        return 10
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell: HomeTimeLineCollectionViewCell = collectionView.dequeueReusableCell(forIndexPath: indexPath)
        
        let imgArray = [UIImage(named: "timeline01.png"), UIImage(named: "timeline02.png")]
        cell.imageView.image = imgArray[indexPath.row % 2]
        
        return cell
    }
}

extension AccountTimelineViewController: UICollectionViewDelegate {
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        UIApplication.shared.topPresentedNavigationController?.pushViewController(ActivityViewController.instantiate(), animated: true)
    }
}

extension AccountTimelineViewController: UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        let cellWidth = floor(collectionView.bounds.width * 4 / 5)
        
        return CGSize(width: cellWidth, height: cellWidth)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        
        return floor(collectionView.bounds.width * 1 / 10)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        
        return 0
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        
        return UIEdgeInsets.zero
    }
}

// MARK: - XLPagerTabStrip

extension AccountTimelineViewController: IndicatorInfoProvider {
    
    func indicatorInfo(for pagerTabStripController: PagerTabStripViewController) -> IndicatorInfo {
        
        return IndicatorInfo(title: titleStr)
    }
}

// MARK: - Storyboard Instantiable

extension AccountTimelineViewController: StoryboardInstantiable {}
