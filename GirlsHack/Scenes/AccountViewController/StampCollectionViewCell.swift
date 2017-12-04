//
//  StampCollectionViewCell.swift
//  GirlsHack
//
//  Created by 藤井陽介 on 2017/12/02.
//  Copyright © 2017年 touyou. All rights reserved.
//

import UIKit

class StampCollectionViewCell: UICollectionViewCell, NibInstantiable, Reusable {

    @IBOutlet weak var photoImageView: UIImageView!
    @IBOutlet weak var iconImageView: UIImageView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
}
