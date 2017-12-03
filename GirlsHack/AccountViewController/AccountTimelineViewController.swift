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

extension AccountTimelineViewController: UICollectionViewDataSource {
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        
        return 10
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell: HomeTimeLineCollectionViewCell = collectionView.dequeueReusableCell(forIndexPath: indexPath)
        
        cell.backgroundColor = .white
        cell.layer.masksToBounds = false
        cell.layer.shadowOffset = CGSize(width: 0.0, height: 0.0)
        cell.layer.shadowOpacity = 0.6
        cell.layer.shadowRadius = 2.0
        
        return cell
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

extension AccountTimelineViewController: IndicatorInfoProvider {
    
    func indicatorInfo(for pagerTabStripController: PagerTabStripViewController) -> IndicatorInfo {
        
        return IndicatorInfo(title: titleStr)
    }
}

extension AccountTimelineViewController: StoryboardInstantiable {}
