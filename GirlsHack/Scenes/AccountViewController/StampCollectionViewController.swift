//
//  StampCollectionViewController.swift
//  GirlsHack
//
//  Created by 藤井陽介 on 2017/12/02.
//  Copyright © 2017年 touyou. All rights reserved.
//

import UIKit

class StampCollectionViewController: UIViewController {
    
    @IBOutlet weak var collectionView: UICollectionView! {
        
        didSet {
            
            collectionView.dataSource = self
            collectionView.delegate = self
            collectionView.isScrollEnabled = false
            
            collectionView.register(StampCollectionViewCell.self)
        }
    }
    
    var stamps: [Stamp] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewWillLayoutSubviews() {
        
        super.viewWillLayoutSubviews()
        
        self.view.layoutMargins = UIEdgeInsets.zero
    }
}

// MARK: - UICollectionViewDataSource

extension StampCollectionViewController: UICollectionViewDataSource {
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        
//        return StampPageViewController.stampCountPerPage
        return 11
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell: StampCollectionViewCell = collectionView.dequeueReusableCell(forIndexPath: indexPath)

//        if indexPath.row < stamps.count {
        
//            cell.iconImageView.image = stamps[indexPath.row].iconImage
            cell.iconImageView.image = UIImage(named: "stamp")
//            cell.photoImageView.image = stamps[indexPath.row].photo
            cell.photoImageView.image = AccountHelper.shared.dummyImage[indexPath.row % 3]
//        } else {
//
//            // TODO: スタンプが無い時
//        }
        
        return cell
    }
}

// MARK: - UICollectionViewDelegateFlowLayout

extension StampCollectionViewController: UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        let cellWidth = floor((collectionView.bounds.width - 2.0 - 20.0) / 3)
        
        return CGSize(width: cellWidth, height: cellWidth)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        
        return 1.0
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        
        return 1.0
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        
        return UIEdgeInsets(top: 10.0, left: 10.0, bottom: 10.0, right: 10.0)
    }
}

// MARK: - Storyboard Instantiable

extension StampCollectionViewController: StoryboardInstantiable {}
