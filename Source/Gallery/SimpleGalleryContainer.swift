//
//  SimpleGalleryContainer.swift
//  YUSimpleGallery
//
//  Created by Michael Yudin on 17.07.2018.
//  Copyright © 2018 Michael Yudin. All rights reserved.
//

import UIKit
import Photos

public protocol SimpleGalleryProtocol {
    func cancel(_ container:SimpleGalleryContainer)
    func done(_ container:SimpleGalleryContainer, selected: [PHAsset])
}

open class SimpleGalleryContainer: UIViewController {
    
    @IBOutlet weak var doneButton: UIButton!
    var gallery: SimpleGallery!
    public var delegate: SimpleGalleryProtocol!
    
    open override func viewDidLoad() {
        super.viewDidLoad()
        setup(selected: [])
    }
    
    fileprivate func setup(selected: [PHAsset]) {
        guard gallery != nil else { assertionFailure(); return }
        gallery.selected = selected
        gallery.reloadData { gallery in
            gallery.collectionView?.reloadData()
        }
    }

    @IBAction func doneButtonDidTapped(_ sender: Any) {
        guard let selectedPaths = gallery.collectionView?.indexPathsForSelectedItems else { return }
        guard let delegate = delegate else { assertionFailure(); return }
        let selectedMediaItems = selectedPaths.map { ip -> PHAsset in
            return gallery.mediaItems[ip.row]
        }
        delegate.done(self, selected: selectedMediaItems)
        self.dismiss(animated: true, completion: nil)
    }
    
    open override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if (segue.identifier == "embedYUSimpleGallery") {
            gallery = segue.destination as! SimpleGallery
        }
    }
}

extension SimpleGalleryContainer {
    public class func instantinate() -> SimpleGalleryContainer {
        let bundle = Bundle(for: AssetManager.self)
        let storyboardName = "SimpleGalleryContainer"
        let storyboard = UIStoryboard(name: storyboardName, bundle: bundle)
        let controller = storyboard.instantiateInitialViewController() as! SimpleGalleryContainer
        return controller
    }
    
    open override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
}
