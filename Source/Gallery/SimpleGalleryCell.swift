//
//  SimpleGalleryCell.swift
//  SimpleGallery
//
//  Created by Michael Yudin on 17.07.2018.
//  Copyright © 2018 Michael Yudin. All rights reserved.
//

import UIKit
import Photos

class SimpleGalleryCell: UICollectionViewCell {

    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var checkImage: UIImageView!
    @IBOutlet weak var videoIconImage: UIImageView!
    
    override var isSelected: Bool {
        didSet {
            if (isSelected) {
                checkImage.image = AssetManager.getImage("checked")
                return
            }
            checkImage.image = AssetManager.getImage("unchecked")
        }
    }
    
    func configure(asset: PHAsset) {
        let imageManager = PHImageManager.default()
        videoIconImage.isHidden = asset.mediaType == .image
        let requestOptions = PHImageRequestOptions()
        requestOptions.deliveryMode = .highQualityFormat
        requestOptions.isNetworkAccessAllowed = true
        DispatchQueue.global(qos: .utility).async {
            imageManager.requestImage(for: asset, targetSize: self.imageView.bounds.size, contentMode: .aspectFill, options: requestOptions) { image, info in
                if let info = info, info["PHImageFileUTIKey"] == nil {
                    DispatchQueue.main.async(execute: {
                        self.imageView.image = image
                    })
                }
            }
        }
        imageView.contentMode = .scaleAspectFill
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        checkImage.image = AssetManager.getImage("unchecked")
        imageView.image = UIImage()
        imageView.backgroundColor = UIColor.clear
        videoIconImage.isHidden = true
    }
}


