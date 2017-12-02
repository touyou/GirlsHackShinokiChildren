//
//  UICollectionView+Extensions.swift
//  MusicAppClone
//
//  Created by 藤井陽介 on 2017/09/16.
//  Copyright © 2017年 藤井陽介. All rights reserved.
//

import UIKit

// MARK: - Reuse Extension

extension UICollectionView {
    
    // MARK: Cell
    
    func register<T: UICollectionViewCell>(_: T.Type) where T: Reusable {
        
        register(T.self, forCellWithReuseIdentifier: T.defaultReuseIdentifier)
    }
    
    func register<T: UICollectionViewCell>(_: T.Type) where T: Reusable, T: NibLoadable {
        
        let bundle = Bundle(for: T.self)
        let nib = UINib(nibName: T.nibName, bundle: bundle)
        
        register(nib, forCellWithReuseIdentifier: T.defaultReuseIdentifier)
    }
    
    func dequeueReusableCell<T: UICollectionViewCell>(forIndexPath indexPath: IndexPath) -> T where T: Reusable {
        
        guard let cell = dequeueReusableCell(withReuseIdentifier: T.defaultReuseIdentifier, for: indexPath) as? T else {
            
            fatalError("\(T.defaultReuseIdentifier)のセルの再利用中エラーが発生しました。")
        }
        
        return cell
    }
    
    // MARK: Supplementary View
    
    func register<T: UICollectionReusableView>(_: T.Type, forSupplementaryViewOfKind kind: String) where T: Reusable {
        
        register(T.self, forSupplementaryViewOfKind: kind, withReuseIdentifier: T.defaultReuseIdentifier)
    }
    
    func register<T: UICollectionReusableView>(_: T.Type, forSupplementaryViewOfKind kind: String) where T: Reusable, T: NibLoadable {
        
        let bundle = Bundle(for: T.self)
        let nib = UINib(nibName: T.nibName, bundle: bundle)
        
        register(nib, forSupplementaryViewOfKind: kind, withReuseIdentifier: T.defaultReuseIdentifier)
    }
    
    func dequeueReusableSupplementaryView<T: UICollectionReusableView>(ofKind elementKind: String, for indexPath: IndexPath) -> T where T: Reusable {
        
        guard let view = dequeueReusableSupplementaryView(ofKind: elementKind, withReuseIdentifier: T.defaultReuseIdentifier, for: indexPath) as? T else {
            
            fatalError("\(T.defaultReuseIdentifier)のビューの再利用中エラーが発生しました。")
        }
        
        return view
    }
}
