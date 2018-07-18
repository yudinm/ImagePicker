//
//  SimpleGallery.swift
//  SimpleGallery
//
//  Created by Michael Yudin on 17.07.2018.
//  Copyright © 2018 Michael Yudin. All rights reserved.
//

import UIKit
import Photos

open class SimpleGallery: UICollectionViewController {
  
    var mediaItems: [PHAsset] = []
    var selected: [PHAsset]!
    
    open override func viewDidLoad() {
        super.viewDidLoad()
        
        self.collectionView?.collectionViewLayout = SimpleGalleryFlowLayout(collectionView: collectionView!)
        self.collectionView?.allowsMultipleSelection = true
    }


}

extension SimpleGallery {

    open override func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    open override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return mediaItems.count
    }
    
    open override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let row = indexPath.row
        let mediaItem = mediaItems[row]
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "YUSimpleGalleryCell", for: indexPath) as! SimpleGalleryCell
        cell.configure(asset: mediaItem)
        return cell
    }
}

extension SimpleGallery {
    
    open override func viewWillTransition(to size: CGSize, with coordinator: UIViewControllerTransitionCoordinator) {
        super.viewWillTransition(to: size, with: coordinator)
        coordinator.animate(alongsideTransition: { context in
            let isPortrait = size.height > size.width
            let layout = self.collectionView?.collectionViewLayout as! SimpleGalleryFlowLayout
            layout.updateLayout(collectionView: self.collectionView!, isPortrait: isPortrait)
        }, completion: nil)
    }
}

extension SimpleGallery {
    
    open func reloadData(_ completion: @escaping (_ gallery: SimpleGallery) -> Void) {
        guard PHPhotoLibrary.authorizationStatus() == .authorized else { return }
        
        DispatchQueue.global(qos: .utility).async {
            let fetchResult = PHAsset.fetchAssets(with: PHFetchOptions())
            
            if fetchResult.count > 0 {
                self.mediaItems = [PHAsset]()
                fetchResult.enumerateObjects({ object, _, _ in
                    self.mediaItems.insert(object, at: 0)
                })
                
                DispatchQueue.main.async {
                    completion(self)
                }
            }
        }
    }
    
}
