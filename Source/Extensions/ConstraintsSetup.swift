import UIKit

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
