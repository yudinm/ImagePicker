//
//  SimpleGalleryFlowLayout.swift
//  SimpleGallery
//
//  Created by Michael Yudin on 17.07.2018.
//  Copyright © 2018 Michael Yudin. All rights reserved.
//

import UIKit

class SimpleGalleryFlowLayout: UICollectionViewFlowLayout {
    
    init(collectionView: UICollectionView) {
        super.init()
        
        minimumLineSpacing = 2
        minimumInteritemSpacing = 2
        sectionInset = UIEdgeInsetsMake(minimumLineSpacing, minimumLineSpacing, minimumLineSpacing, minimumLineSpacing)
        updateLayout(collectionView: collectionView, isPortrait: collectionView.bounds.height > collectionView.bounds.width)
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    func updateLayout(collectionView: UICollectionView, isPortrait: Bool) {
        var itemsInRow = CGFloat(3)
        if (!isPortrait) {
            itemsInRow = 6
        }
        let width = collectionView.bounds.width - minimumLineSpacing
        let cellWidth = CGFloat(width / itemsInRow) - minimumLineSpacing
        itemSize = CGSize(width: cellWidth, height: cellWidth)
    }

    
}
