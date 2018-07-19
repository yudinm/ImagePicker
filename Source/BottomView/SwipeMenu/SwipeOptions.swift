//
//  SwipeOptions.swift
//  ios-camera-swipe-options
//
//  Created by Minhaz Panara on 05/09/17.
//

import UIKit

protocol SwipeOptionsDelegate {
    func didSwipeToItem(_ item: String, index: Int)
}

class SwipeOptions: UIView, UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
  
    // params
    var items: Array<String> = []
    var swippableView: UIView! {
        didSet {
            let directions: [UISwipeGestureRecognizerDirection] = [.right, .left]
            for direction in directions {
                let gesture = UISwipeGestureRecognizer(target: self, action: #selector(handleSwipeGesture(_:)))
                gesture.direction = direction
                swippableView.addGestureRecognizer(gesture)
            }
            
            appliedSwipeGestures = true
        }
    }
    var delegate: SwipeOptionsDelegate!
    
    // private
    private let swipeCellWidth = 60 as CGFloat
    private var theCollectionView: UICollectionView!
    private var unitIndex: Int = 0
    private var appliedSwipeGestures: Bool = false
    
    override func draw(_ rect: CGRect) {
        superview?.draw(rect)
        let gradient = CAGradientLayer()
        gradient.frame = self.bounds
        gradient.startPoint = CGPoint(x: 0.0, y: 0.5)
        gradient.endPoint = CGPoint(x: 1.0, y: 0.5)
        gradient.colors = [UIColor.clear.cgColor, UIColor.black.cgColor, UIColor.black.cgColor, UIColor.clear.cgColor]
        gradient.locations = [0, 0.4, 0.6, 1]
        self.layer.mask = gradient
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        self.initialize()
    }
    
    private func initialize() {
        
        // setup collection view
        self.setupCollectionView()
    }
    
    func setup() {
        
        // setup collection view
        self.setupCollectionView()
    }
    
    //MARK: - Setup unit collection view
    private var flowlayout : UICollectionViewFlowLayout!
    private func setupCollectionView()
    {
        // swipe gestures
        if swippableView != nil && appliedSwipeGestures == false {
            
            let directions: [UISwipeGestureRecognizerDirection] = [.right, .left]
            for direction in directions {
                let gesture = UISwipeGestureRecognizer(target: self, action: #selector(handleSwipeGesture(_:)))
                gesture.direction = direction
                swippableView.addGestureRecognizer(gesture)
            }
            
            appliedSwipeGestures = true
        }
        
        // flow layout
        if flowlayout == nil {
            flowlayout = UICollectionViewFlowLayout()
        }
        flowlayout.scrollDirection = .horizontal
        flowlayout.minimumLineSpacing = 0.0
        flowlayout.minimumInteritemSpacing = 5.0
        
        // collection view
        let frame = CGRect(x: 0, y: 0, width: self.bounds.size.width, height: self.bounds.size.height)
        if self.theCollectionView == nil {
            
            self.theCollectionView = UICollectionView(frame: frame, collectionViewLayout: flowlayout)
            if #available(iOS 11.0, *) {
                self.theCollectionView.contentInsetAdjustmentBehavior = .never
            } else {
                // Fallback on earlier versions
            }
            //SwipeItemCell
            self.theCollectionView.register(SwipeItemCell.self, forCellWithReuseIdentifier: "iOSSwipeItemCell")
            self.theCollectionView.allowsMultipleSelection = false
            theCollectionView.translatesAutoresizingMaskIntoConstraints = false
            self.addSubview(self.theCollectionView)
            
            for attribute: NSLayoutAttribute in [.width, .left, .top, .bottom] {
                addConstraint(NSLayoutConstraint(item: theCollectionView, attribute: attribute,
                                                 relatedBy: .equal, toItem: self, attribute: attribute,
                                                 multiplier: 1, constant: 0))
            }
            
        } else {
            self.theCollectionView.frame = frame
            self.theCollectionView.collectionViewLayout = flowlayout
        }
        
        // option collection view
        self.theCollectionView.delegate = self
        self.theCollectionView.dataSource = self
        
        // reload
        self.theCollectionView.reloadData()
        theCollectionView.backgroundColor = UIColor.clear
//        self.theCollectionView.setBorder(1, color: UIColor.red)
    }
    
    @objc private func handleSwipeGesture(_ recognizer: UISwipeGestureRecognizer) {
        
        var prev = NSNotFound
        if recognizer.direction == .left {
//            print("--> left swipe done")
            if self.unitIndex < (items.count) - 1 {
                prev = self.unitIndex
                self.unitIndex += 1
            }
        }
        else if recognizer.direction == .right {
//            print("---> right swipe done")
            if self.unitIndex > 0 {
                prev = self.unitIndex
                self.unitIndex -= 1
            }
        }
        if prev != NSNotFound {
            self.deselectItemAtIndex(index: prev)
        }
        self.selectItemAtIndex(index: self.unitIndex, animated: true)
    }
    
    //MARK: - select item at index
    func selectItemAtIndex(index: Int, animated: Bool) {
        if index < items.count {
            // select default index
            let indexPath = IndexPath(item: index, section: 0)
            self.collectionView(self.theCollectionView, didSelectItemAt: indexPath, animated: animated)
        } else {
            let indexPath = IndexPath(item: 0, section: 0)
            self.collectionView(self.theCollectionView, didSelectItemAt: indexPath, animated: animated)
        }
    }
    
    func deselectItemAtIndex(index: Int) {
        // select default index
        let indexPath = IndexPath(item: index, section: 0)
        self.collectionView(self.theCollectionView, didDeselectItemAt: indexPath)
    }
    
    //MARK: - UICollectionViewDataSource
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.items.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "iOSSwipeItemCell", for: indexPath) as! SwipeItemCell
        cell.setText(self.items[indexPath.item])
        return cell
    }
    
    //MARK: - UICollectionViewDelegateFlowLayout
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: swipeCellWidth, height: 20)
    }
    
    //MARK: - UICollectionViewDelegate
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        self.collectionView(collectionView, didSelectItemAt: indexPath, animated: true)
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath, animated: Bool) {

        // deselect previous
        self.deselectItemAtIndex(index: self.unitIndex)
        
        // all selected items
        let selectedItems = collectionView.indexPathsForSelectedItems
        for itm in selectedItems! {
            self.deselectItemAtIndex(index: itm.item)
        }
        
        // select current
        guard let cell = collectionView.cellForItem(at: indexPath) as? SwipeItemCell else {
            return
        }
        cell.cellSelect()
        self.unitIndex = indexPath.item
        
        // scroll to content offset
//        let currentOffset = self.theCollectionView.contentOffset
        let size = self.theCollectionView.bounds.size
        let width = size.width > size.height ? size.width : size.height
        let mid = -(width * 0.5)
        let x =  mid + self.swipeCellWidth * 0.5 + CGFloat(self.unitIndex) * self.swipeCellWidth as CGFloat
        let offset = CGPoint(x: x, y: 0)
        self.theCollectionView.setContentOffset(offset, animated: animated)
        
        // perform delegate
        self.delegate.didSwipeToItem(self.items[indexPath.item], index: indexPath.item)
    }
    
    func collectionView(_ collectionView: UICollectionView, didDeselectItemAt indexPath: IndexPath) {

        guard let cell = collectionView.cellForItem(at: indexPath) as? SwipeItemCell else {
            return
        }
        cell.cellDeselect()
    }

}
