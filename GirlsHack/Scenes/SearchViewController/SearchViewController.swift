//
//  SearchViewController.swift
//  GirlsHack
//
//  Created by 藤井陽介 on 2017/12/02.
//  Copyright © 2017年 touyou. All rights reserved.
//

import UIKit
import Kingfisher

class SearchViewController: UIViewController {
    
    @IBOutlet weak var collectionView: UICollectionView! {
        
        didSet {
            collectionView.dataSource = self
            collectionView.delegate = self
            collectionView.register(SearchResultCollectionViewCell.self)
        }
    }
    @IBOutlet weak var searchBar: UISearchBar!
    
    var searchPost: [Post] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        AccountHelper.shared.fetchQuery(for: "posts", limit: 100).getDocuments() { snapshot, err in
            
            if let err = err {
                
                print("Fetch Error: \(err.localizedDescription)")
            } else {
                
                guard let snapshot = snapshot else {
                    
                    return
                }
                
                self.searchPost = snapshot.documents.map {
                    
                    Post(dictionary: $0.data())!
                }
            }
        }
    }
}

// MARK: - CollectionViewDataSource

extension SearchViewController: UICollectionViewDataSource {
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        
//        return searchPost.count
        return 100
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell: SearchResultCollectionViewCell = collectionView.dequeueReusableCell(forIndexPath: indexPath)
        
//        cell.imageView.kf.setImage(with: URL(string: searchPost[indexPath.row].photoURL))
        
        cell.imageView.image = AccountHelper.shared.dummyImage[indexPath.row % 3]
        
        return cell
    }
}

// MARK: - CollectionViewFlowLayout

extension SearchViewController: UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        let cellWidth = floor(collectionView.bounds.width / 2)
        
        return CGSize(width: cellWidth, height: cellWidth / 4.0 * 3.0)
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
