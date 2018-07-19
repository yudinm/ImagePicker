//
//  SwipeMenuView.swift
//  ImagePicker
//
//  Created by Michael Yudin on 10.07.2018.
//

// TODO: Fix position on changing orientation

import UIKit

class SwipeMenuView: SwipeOptions {

    
    init() {
        super.init(frame: .zero)
        
        backgroundColor = UIColor.clear
        setupiOSSwipableView()
        
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
