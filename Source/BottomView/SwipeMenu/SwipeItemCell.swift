//
//  SwipeItemCell.swift
//  ios-camera-swipe-options
//
//  Created by Minhaz Panara on 05/09/17.
//

import UIKit

class SwipeItemCell: UICollectionViewCell {
    
    var lblTitle: UILabel!
    
    let fontDefault     = UIFont(name: "HelveticaNeue", size: 13)
    let fontSelected    = UIFont(name: "HelveticaNeue-Medium", size: 13)
    
    let textColorDefault    = UIColor.white
    let textColorSelected   = UIColor.init(red: 247/255, green: 198/255, blue: 0/255, alpha: 1) // 247, 198, 0 #f7c600
    
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        self.cellDeselect()
    }
    
    func setText(_ text: String) {
        if self.lblTitle == nil {
            self.lblTitle = UILabel(frame: CGRect(x: 0, y: 0, width: self.bounds.size.width, height: self.bounds.size.height))
            self.lblTitle.font = fontDefault
            self.lblTitle.textColor = textColorDefault
            self.lblTitle.textAlignment = .center
            self.addSubview(self.lblTitle)
        }
        self.lblTitle.text = text
    }
    
    func cellSelect() {
        //        print("select : \(String(describing: self.lblTitle.text))")
        self.lblTitle.font = fontSelected
        self.lblTitle.textColor = textColorSelected
    }
    
    func cellDeselect() {
        //        print("Deselect : \(String(describing: self.lblTitle.text))")
        self.lblTitle.font = fontDefault
        self.lblTitle.textColor = textColorDefault
    }
}
