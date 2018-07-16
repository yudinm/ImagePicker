import UIKit

// MARK: - BottomContainer autolayout

extension BottomContainerView {
    
    func setupConstraints() {
//
//        for attribute: NSLayoutAttribute in [.centerX] {
//            addConstraint(NSLayoutConstraint(item: pickerButton, attribute: attribute,
//                                             relatedBy: .equal, toItem: self, attribute: attribute,
//                                             multiplier: 1, constant: 0))
//
//            addConstraint(NSLayoutConstraint(item: pickerVideoButton, attribute: attribute,
//                                             relatedBy: .equal, toItem: self, attribute: attribute,
//                                             multiplier: 1, constant: 0))
//
//            addConstraint(NSLayoutConstraint(item: borderPickerButton, attribute: attribute,
//                                             relatedBy: .equal, toItem: self, attribute: attribute,
//                                             multiplier: 1, constant: 0))
//        }
//
//        for attribute: NSLayoutAttribute in [.centerY] {
//            addConstraint(NSLayoutConstraint(item: pickerButton, attribute: attribute,
//                                             relatedBy: .equal, toItem: self, attribute: attribute,
//                                             multiplier: 1, constant: 8))
//
//            addConstraint(NSLayoutConstraint(item: pickerVideoButton, attribute: attribute,
//                                             relatedBy: .equal, toItem: self, attribute: attribute,
//                                             multiplier: 1, constant: 8))
//
//            addConstraint(NSLayoutConstraint(item: borderPickerButton, attribute: attribute,
//                                             relatedBy: .equal, toItem: self, attribute: attribute,
//                                             multiplier: 1, constant: 8))
//        }
//
//        for attribute: NSLayoutAttribute in [.width, .left, .top] {
//            addConstraint(NSLayoutConstraint(item: topSeparator, attribute: attribute,
//                                             relatedBy: .equal, toItem: self, attribute: attribute,
//                                             multiplier: 1, constant: 0))
//        }
//
//        for attribute: NSLayoutAttribute in [.width, .height] {
//            addConstraint(NSLayoutConstraint(item: pickerButton, attribute: attribute,
//                                             relatedBy: .equal, toItem: nil, attribute: .notAnAttribute,
//                                             multiplier: 1, constant: ButtonPicker.Dimensions.buttonSize))
//
//            addConstraint(NSLayoutConstraint(item: pickerVideoButton, attribute: attribute,
//                                             relatedBy: .equal, toItem: nil, attribute: .notAnAttribute,
//                                             multiplier: 1, constant: ButtonVideoPicker.Dimensions.buttonSize))
//
//            addConstraint(NSLayoutConstraint(item: borderPickerButton, attribute: attribute,
//                                             relatedBy: .equal, toItem: nil, attribute: .notAnAttribute,
//                                             multiplier: 1, constant: ButtonPicker.Dimensions.buttonBorderSize))
//
//            addConstraint(NSLayoutConstraint(item: stackView, attribute: attribute,
//                                             relatedBy: .equal, toItem: nil, attribute: .notAnAttribute,
//                                             multiplier: 1, constant: ImageStackView.Dimensions.imageSize))
//        }
//
//
//        addConstraint(NSLayoutConstraint(item: stackView, attribute: .centerY,
//                                         relatedBy: .equal, toItem: self, attribute: .centerY,
//                                         multiplier: 1, constant: 8))
//
//        addConstraint(NSLayoutConstraint(item: stackView, attribute: .trailing,
//                                         relatedBy: .equal, toItem: pickerButton, attribute: .leading,
//                                         multiplier: 1, constant: -stackView.bounds.width))
//
//        addConstraint(NSLayoutConstraint(item: topSeparator, attribute: .height,
//                                         relatedBy: .equal, toItem: nil, attribute: .notAnAttribute,
//                                         multiplier: 1, constant: 1))
//
//        addConstraint(NSLayoutConstraint(item: swipeMenuView, attribute: .top,
//                                              relatedBy: .equal, toItem: topSeparator, attribute: .bottom,
//                                              multiplier: 1, constant: 0))
//
////        addConstraint(NSLayoutConstraint(item: swipeMenuView, attribute: .bottom,
////                                              relatedBy: .equal, toItem: doneButton, attribute: .top,
////                                              multiplier: 1, constant: 0))
//
//        addConstraint(NSLayoutConstraint(item: swipeMenuView, attribute: .left,
//                                         relatedBy: .equal, toItem: self, attribute: .left,
//                                         multiplier: 1, constant: 0))
//
//        addConstraint(NSLayoutConstraint(item: swipeMenuView, attribute: .right,
//                                         relatedBy: .equal, toItem: self, attribute: .right,
//                                         multiplier: 1, constant: 0))
//
//        //
//        let constraint = NSLayoutConstraint(item: doneButton, attribute: .left,
//                                            relatedBy: .equal, toItem: borderPickerButton, attribute: .right,
//                                            multiplier: 1, constant: 8)
//        constraint.priority = .defaultLow
//        addConstraint(constraint)
//
//        addConstraint(NSLayoutConstraint(item: doneButton, attribute: .right,
//                                          relatedBy: .greaterThanOrEqual, toItem: self, attribute: .right,
//                                          multiplier: 1, constant: 0))
//
//
//
//        addConstraint(NSLayoutConstraint(item: doneButton, attribute: .centerY,
//                                         relatedBy: .equal, toItem: self, attribute: .centerY,
//                                         multiplier: 1, constant: 8))
    }
}

// MARK: - TopView autolayout

extension TopView {
    
    func setupConstraints() {
//        addConstraint(NSLayoutConstraint(item: flashButton, attribute: .left,
//                                         relatedBy: .equal, toItem: self, attribute: .left,
//                                         multiplier: 1, constant: Dimensions.leftOffset))
//
//        addConstraint(NSLayoutConstraint(item: flashButton, attribute: .centerY,
//                                         relatedBy: .equal, toItem: self, attribute: .centerY,
//                                         multiplier: 1, constant: 0))
//
//        addConstraint(NSLayoutConstraint(item: flashButton, attribute: .width,
//                                         relatedBy: .equal, toItem: nil, attribute: .notAnAttribute,
//                                         multiplier: 1, constant: 55))
//
//        if configuration.canRotateCamera {
//            addConstraint(NSLayoutConstraint(item: rotateCamera, attribute: .right,
//                                             relatedBy: .equal, toItem: self, attribute: .right,
//                                             multiplier: 1, constant: Dimensions.rightOffset))
//
//            addConstraint(NSLayoutConstraint(item: rotateCamera, attribute: .centerY,
//                                             relatedBy: .equal, toItem: self, attribute: .centerY,
//                                             multiplier: 1, constant: 0))
//
//            addConstraint(NSLayoutConstraint(item: rotateCamera, attribute: .width,
//                                             relatedBy: .equal, toItem: nil, attribute: .notAnAttribute,
//                                             multiplier: 1, constant: 55))
//
//            addConstraint(NSLayoutConstraint(item: rotateCamera, attribute: .height,
//                                             relatedBy: .equal, toItem: nil, attribute: .notAnAttribute,
//                                             multiplier: 1, constant: 55))
//        }
        
    }
}

// MARK: - Controller autolayout

extension ImagePickerController {
    
    func setupConstraints() {
//        let attributes: [NSLayoutAttribute] = [.bottom, .right, .width]
//        let topViewAttributes: [NSLayoutAttribute] = [.left, .width]
//
//        for attribute in attributes {
//            view.addConstraint(NSLayoutConstraint(item: bottomContainer, attribute: attribute,
//                                                  relatedBy: .equal, toItem: view, attribute: attribute,
//                                                  multiplier: 1, constant: 0))
//        }
//
//        for attribute: NSLayoutAttribute in [.left, .top, .width] {
//            view.addConstraint(NSLayoutConstraint(item: cameraController.view, attribute: attribute,
//                                                  relatedBy: .equal, toItem: view, attribute: attribute,
//                                                  multiplier: 1, constant: 0))
//        }
//
//        for attribute in topViewAttributes {
//            view.addConstraint(NSLayoutConstraint(item: topView, attribute: attribute,
//                                                  relatedBy: .equal, toItem: self.view, attribute: attribute,
//                                                  multiplier: 1, constant: 0))
//        }
//
//        if #available(iOS 11.0, *) {
//            view.addConstraint(NSLayoutConstraint(item: topView, attribute: .top,
//                                                  relatedBy: .equal, toItem: view.safeAreaLayoutGuide,
//                                                  attribute: .top,
//                                                  multiplier: 1, constant: 0))
//        } else {
//            view.addConstraint(NSLayoutConstraint(item: topView, attribute: .top,
//                                                  relatedBy: .equal, toItem: view,
//                                                  attribute: .top,
//                                                  multiplier: 1, constant: 0))
//        }
//
//        if #available(iOS 11.0, *) {
//            let heightPadding = UIApplication.shared.keyWindow!.safeAreaInsets.bottom
//            view.addConstraint(NSLayoutConstraint(item: bottomContainer, attribute: .height,
//                                                  relatedBy: .equal, toItem: nil,
//                                                  attribute: .notAnAttribute,
//                                                  multiplier: 1,
//                                                  constant: BottomContainerView.Dimensions.height + heightPadding))
//        } else {
//            view.addConstraint(NSLayoutConstraint(item: bottomContainer, attribute: .height,
//                                                  relatedBy: .equal, toItem: nil,
//                                                  attribute: .notAnAttribute,
//                                                  multiplier: 1,
//                                                  constant: BottomContainerView.Dimensions.height))
//        }
//
//        view.addConstraint(NSLayoutConstraint(item: topView, attribute: .height,
//                                              relatedBy: .equal, toItem: nil, attribute: .notAnAttribute,
//                                              multiplier: 1, constant: TopView.Dimensions.height))
//
//        view.addConstraint(NSLayoutConstraint(item: cameraController.view, attribute: .height,
//                                              relatedBy: .equal, toItem: view, attribute: .height,
//                                              multiplier: 1, constant: 0 /*-BottomContainerView.Dimensions.height*/))
//
//        for attribute: NSLayoutAttribute in [.left, .top, .width, .bottom] {
//            view.addConstraint(NSLayoutConstraint(item: overlayRotateYourPhoneView, attribute: attribute,
//                                                  relatedBy: .equal, toItem: view, attribute: attribute,
//                                                  multiplier: 1, constant: 0))
//        }
//
    }
}


extension ButtonPicker {
    
    func setupConstraints() {
        let attributes: [NSLayoutAttribute] = [.centerX, .centerY]
        
        for attribute in attributes {
            addConstraint(NSLayoutConstraint(item: numberLabel, attribute: attribute,
                                             relatedBy: .equal, toItem: self, attribute: attribute,
                                             multiplier: 1, constant: 0))
        }
    }
}

extension ButtonVideoPicker {
    
    func setupConstraints() {
        let attributes: [NSLayoutAttribute] = [.centerX, .centerY]
        
        for attribute in attributes {
            addConstraint(NSLayoutConstraint(item: numberLabel, attribute: attribute,
                                             relatedBy: .equal, toItem: self, attribute: attribute,
                                             multiplier: 1, constant: 0))
        }
    }
}

extension SwipeMenuView {
    
    func setupConstraints() {
        
        
//        addConstraint(NSLayoutConstraint(item: self, attribute: .width,
//                                         relatedBy: .equal, toItem: nil, attribute: .notAnAttribute,
//                                         multiplier: 1, constant: 123))
//        addConstraint(NSLayoutConstraint(item: self, attribute: .height,
//                                         relatedBy: .equal, toItem: nil, attribute: .notAnAttribute,
//                                         multiplier: 1, constant: 32))
    }
    
}
