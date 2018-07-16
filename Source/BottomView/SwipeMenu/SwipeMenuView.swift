//
//  SwipeMenuView.swift
//  ImagePicker
//
//  Created by Michael Yudin on 10.07.2018.
//

// TODO: Fix position on changing orientation

import UIKit

class SwipeMenuView: iOSSwipeOptions {

    
    init() {
        super.init(frame: .zero)
        
        backgroundColor = UIColor.clear
        setupiOSSwipableView()
        setupConstraints()
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setupiOSSwipableView() {
        
//        self.delegate = self
//        self.swippableView = self
        self.items = [/*"TIME-LAPSE","SLO-MO",*/"VIDEO","PHOTO"/*,"SQUARE","PANO"*/]
        self.setup()
    }
    
}
