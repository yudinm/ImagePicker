
import UIKit
import ImagePicker
import AVKit
import Photos

class DemoViewController: UIViewController {
    
    lazy var button: UIButton = self.makeButton()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = UIColor.white
        view.addSubview(button)
        button.translatesAutoresizingMaskIntoConstraints = false
        
        view.addConstraint(
            NSLayoutConstraint(item: button, attribute: .centerX,
                               relatedBy: .equal, toItem: view,
                               attribute: .centerX, multiplier: 1,
                               constant: 0))
        
        view.addConstraint(
            NSLayoutConstraint(item: button, attribute: .centerY,
                               relatedBy: .equal, toItem: view,
                               attribute: .centerY, multiplier: 1,
                               constant: 0))
    }
    
    func makeButton() -> UIButton {
        let button = UIButton()
        button.setTitle("Show ImagePicker", for: .normal)
        button.setTitleColor(UIColor.black, for: .normal)
        button.addTarget(self, action: #selector(buttonTouched(button:)), for: .touchUpInside)
        
        return button
    }
    
    @objc func buttonTouched(button: UIButton) {
        let config = Configuration()
        config.doneButtonTitle = "Finish"
        config.noImagesTitle = "Sorry! There are no images here!"
        config.recordLocation = true
        config.allowVideoSelection = true
        
        let controller = ImagePickerController.instantinate(configuration: config)
        controller.delegate = self
        present(controller, animated: true, completion: nil)
    }
}

extension DemoViewController: ImagePickerDelegate {

    func cancelButtonDidPress(_ imagePicker: ImagePickerController) {
        imagePicker.dismiss(animated: true, completion: nil)
    }
    
    func wrapperDidPress(_ imagePicker: ImagePickerController, capturedMediaItems: [String]) {
        let galleryContainer = SimpleGalleryContainer.instantinate()
        galleryContainer.delegate = imagePicker
        galleryContainer.selectedItems = capturedMediaItems
        imagePicker.present(galleryContainer, animated: true, completion: nil)
    }
    
    func doneButtonDidPress(_ imagePicker: ImagePickerController, mediaItems: [String]) {
        imagePicker.dismiss(animated: true, completion: nil)
    }
}


