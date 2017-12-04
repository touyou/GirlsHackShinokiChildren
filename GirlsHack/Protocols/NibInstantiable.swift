//
//  NibInstantiable.swift
//  MusicAppClone
//
//  Created by 藤井陽介 on 2017/09/15.
//  Copyright © 2017年 藤井陽介. All rights reserved.
//

import UIKit

// MARK: - Nib Instantiable

protocol NibInstantiable: NibLoadable {
    
    static var nibName: String { get }
}

extension NibInstantiable {
    
    static func instantiate() -> Self {
        
        return instantiateWithName(name: nibName)
    }
    
    static func instantiateWithOwner(owner: Any?) -> Self {
        
        return instantiateWithName(name: nibName, owner: owner)
    }
    
    static func instantiateWithName(name: String, owner: Any? = nil) -> Self {
        
        let nib = UINib(nibName: name, bundle: nil)
        
        guard let view = nib.instantiate(withOwner: owner, options: nil).first as? Self else {
        
            assert(false, "生成したいViewと同じ名前のxibファイルが見つかりません。")
        }
        
        return view
    }
}
