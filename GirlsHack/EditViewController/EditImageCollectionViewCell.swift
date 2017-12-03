//
//  EditImageCollectionViewCell.swift
//  GirlsHack
//
//  Created by 藤井陽介 on 2017/12/03.
//  Copyright © 2017年 touyou. All rights reserved.
//

import UIKit
import Photos

class EditImageCollectionViewCell: UICollectionViewCell, NibLoadable, Reusable {
    @IBOutlet weak var imageView: UIImageView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    func setAssets(for asset: PHAsset) {
        
        let manager = PHImageManager()
        manager.requestImage(for: asset, targetSize: imageView.frame.size, contentMode: .aspectFill, options: nil, resultHandler: { [weak self] image, info in
            
            guard let `self` = self else {
                
                return
            }
            
            self.imageView.image = image
        })
    }
}
