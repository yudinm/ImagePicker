//
//  OverlayView.swift
//  Cache
//
//  Created by Michael Yudin on 06.07.2018.
//

import UIKit

class OverlayView: UIView {

    lazy var rotateYourPhoneImageView: UIImageView = { [unowned self] in
        let imageView = UIImageView(image: AssetManager.getImage("rotateYourPhone"))
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
        }()
    
    lazy var rotateYourPhoneLabel: UILabel = { [unowned self] in
        let label = UILabel(frame: .zero)
        label.lineBreakMode = NSLineBreakMode.byWordWrapping
        label.numberOfLines = 0
        label.text = "Please rotate your phone\n" +
        "to landscape mode\n" +
        "or select content from\n" +
        "Camera roll"
        label.textColor = UIColor.white
        label.textAlignment = .center
        label.font = UIFont.systemFont(ofSize: 21.0, weight: .medium)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
        }()
    
    init() {
        super.init(frame: .zero)

        self.backgroundColor = UIColor.black.withAlphaComponent(0.7)
        self.addSubview(rotateYourPhoneImageView)
        self.addSubview(rotateYourPhoneLabel)
        setupConstraints()

    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
