//
//  EditViewController.swift
//  GirlsHack
//
//  Created by 藤井陽介 on 2017/12/02.
//  Copyright © 2017年 touyou. All rights reserved.
//

import UIKit
import Photos

class EditViewController: UIViewController {
    
    @IBOutlet weak var collectionView: UICollectionView! {
        
        didSet {
            
            collectionView.dataSource = self
            collectionView.delegate = self
            
            collectionView.register(EditImageCollectionViewCell.self)
            collectionView.register(EditButtonCollectionViewCell.self)
        }
    }
    @IBOutlet weak var previewImageView: UIImageView!
    
    var photoAssets = [PHAsset]() {
        
        didSet {
            
            DispatchQueue.main.async {
                
                self.collectionView.reloadData()
            }
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        libraryRequestAuth()
    }
    
    fileprivate func libraryRequestAuth() {
        
        PHPhotoLibrary.requestAuthorization { [weak self] status in
            
            guard let `self` = self else {
                
                return
            }
            
            switch status {
            case .authorized:
                self.getPhotosInfo()
            default:
                fatalError("authorization error")
            }
        }
    }
    
    func getPhotosInfo() {
        
        let assets: PHFetchResult = PHAsset.fetchAssets(with: .image, options: nil)
        let indexSet = IndexSet((assets.count-7) ..< assets.count)
        self.photoAssets = assets.objects(at: indexSet).reversed()
        
        guard let firstPhoto = photoAssets.first else { return }
        DispatchQueue.main.async {
            
            let manager = PHImageManager()
            manager.requestImage(for: firstPhoto, targetSize: self.previewImageView.frame.size, contentMode: .aspectFill, options: nil, resultHandler: { [weak self] image, info in
                
                guard let `self` = self else {
                    
                    return
                }
                
                self.previewImageView.image = image
            })
        }
    }
    
    @IBAction func touchUpInsideCancelButton(_ sender: Any) {
        
        dismiss(animated: true, completion: nil)
    }
    
}

// MARK: - CollectionViewDataSource

extension EditViewController: UICollectionViewDataSource {
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.photoAssets.count + 2
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        if indexPath.row == 0 || indexPath.row == self.photoAssets.count + 1 {
            
            let cell: EditButtonCollectionViewCell = collectionView.dequeueReusableCell(forIndexPath: indexPath)
            
            cell.titleLabel.text = indexPath.row == 0 ? "カメラで撮る" : "他の写真を選ぶ"
            
            return cell
        }
        
        let cell: EditImageCollectionViewCell = collectionView.dequeueReusableCell(forIndexPath: indexPath)
        
        cell.setAssets(for: photoAssets[indexPath.row - 1])
        
        return cell
    }
}

// MARK: - CollectionViewDelegate

extension EditViewController: UICollectionViewDelegate {
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        if indexPath.row == 0 {
            
            if UIImagePickerController.isSourceTypeAvailable(.camera) {
            
                let picker = UIImagePickerController()
                picker.delegate = self
                picker.sourceType = .camera
                present(picker, animated: true, completion: nil)
            }
            return
        }
        
        if indexPath.row == self.photoAssets.count + 1 {
            
            if UIImagePickerController.isSourceTypeAvailable(.photoLibrary) {
                
                let picker = UIImagePickerController()
                picker.delegate = self
                picker.sourceType = .photoLibrary
                present(picker, animated: true, completion: nil)
            }
            return
        }
        
        let manager = PHImageManager()
        manager.requestImage(for: photoAssets[indexPath.row - 1], targetSize: previewImageView.frame.size, contentMode: .aspectFill, options: nil, resultHandler: { [weak self] image, info in
            
            guard let `self` = self else {
                
                return
            }
            
            self.previewImageView.image = image
        })
    }
}

// MARK: - CollectionViewDelegateFlowLayout

extension EditViewController: UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        let cellWidth = floor((collectionView.bounds.width - 2.0) / 3)
        
        return CGSize(width: cellWidth, height: cellWidth)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        
        return 1.0
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        
        return 1.0
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        
        return UIEdgeInsets.zero
    }
}

// MARK: - ImagePickerDelegate

extension EditViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        
        if let pickedImage = info[UIImagePickerControllerOriginalImage] as? UIImage {
            
            previewImageView.image = pickedImage
        }
        
        picker.dismiss(animated: true, completion: nil)
    }
}
