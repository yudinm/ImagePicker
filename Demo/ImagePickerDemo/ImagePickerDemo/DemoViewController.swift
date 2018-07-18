
import UIKit
import ImagePicker
import AVKit
import Photos

extension PHAsset {
    
    func getURL(completionHandler : @escaping ((_ responseURL: URL?, _ previewImage: UIImage) -> Void)){
        if self.mediaType == .image {
            let options: PHContentEditingInputRequestOptions = PHContentEditingInputRequestOptions()
            options.canHandleAdjustmentData = {(adjustmeta: PHAdjustmentData) -> Bool in
                return true
            }
            self.requestContentEditingInput(with: options, completionHandler: {(contentEditingInput: PHContentEditingInput?, info: [AnyHashable : Any]) -> Void in
                let url = contentEditingInput!.fullSizeImageURL as URL?
                completionHandler(url, UIImage(contentsOfFile: url?.absoluteString ?? "") ?? UIImage() )
            })
        } else if self.mediaType == .video {
            let options: PHVideoRequestOptions = PHVideoRequestOptions()
            options.version = .original
            PHImageManager.default().requestAVAsset(forVideo: self, options: options, resultHandler: {(asset: AVAsset?, audioMix: AVAudioMix?, info: [AnyHashable : Any]?) -> Void in
                if let urlAsset = asset as? AVURLAsset {
                    let localVideoUrl: URL = urlAsset.url as URL
                    completionHandler(localVideoUrl, self.generateThumbnailFromAsset(asset: asset!, forTime: kCMTimeZero))
                } else {
                    completionHandler(nil, UIImage())
                }
            })
        }
    }

    func generateThumbnailFromAsset(asset: AVAsset, forTime time: CMTime) -> UIImage {
        let imageGenerator = AVAssetImageGenerator(asset: asset)
        imageGenerator.appliesPreferredTrackTransform = true
        var actualTime: CMTime = kCMTimeZero
        do {
            let imageRef = try imageGenerator.copyCGImage(at: time, actualTime: &actualTime)
            let image = UIImage(cgImage: imageRef)
            return image
        } catch let error as NSError {
            print("\(error.description). Time: \(actualTime)")
        }
        return UIImage()
    }

}

class DemoViewController: UIViewController, ImagePickerDelegate {
    
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
    
    // MARK: - ImagePickerDelegate
    
    func cancelButtonDidPress(_ imagePicker: ImagePickerController) {
        imagePicker.dismiss(animated: true, completion: nil)
    }
    
    func wrapperDidPress(_ imagePicker: ImagePickerController, capturedMediaItems: inout [PHAsset]) {
        let galleryContainer = SimpleGalleryContainer.instantinate()
        galleryContainer.delegate = self
        imagePicker.present(galleryContainer, animated: true, completion: nil)
    }
//        var lightboxImages = [LightboxImage]()
//        var index = 0
//        allMediaItems.forEach { asset in
//            let text = asset.creationDate?.description ?? ""
//            asset.getURL { url, preivewImage in
//                if let url = url {
//                    switch asset.mediaType {
//                    case .image:
//                        let lbImage = LightboxImage(imageURL: url)
//                        lbImage.text = text
//                        lightboxImages.append(lbImage)
//                    case .video:
//                        lightboxImages.append(LightboxImage(image: preivewImage, text: text, videoURL: url))
//                    default:
//                        print("WTF: \(url)")
//                    }
//                }
//                index += 1
//                if index == allMediaItems.count {
//                    guard lightboxImages.count > 0 else { return }
//                    let lightbox = LightboxController(images: lightboxImages, startIndex: 0)
//                    imagePicker.present(lightbox, animated: true, completion: nil)
//                }
//            }
//        }

//        var mediaItems = [Any]()
//        for asset in allMediaItems {
//            if asset.mediaType == .video {
//                let requestOptions = PHVideoRequestOptions()
//                //            requestOptions.deliveryMode = shouldPreferLowRes ? .fastFormat : .highQualityFormat
//                requestOptions.isNetworkAccessAllowed = true
//
//                imageManager.requestPlayerItem(forVideo: asset, options: requestOptions) { playerItem, info in
//                    if let info = info, info["PHImageFileUTIKey"] == nil {
//                        mediaItems.append(playerItem)
//                    }
//                }
//            } else {
//                let requestOptions = PHImageRequestOptions()
//                //            requestOptions.deliveryMode = shouldPreferLowRes ? .fastFormat : .highQualityFormat
//                requestOptions.isNetworkAccessAllowed = true
//                //                requestOptions.isSynchronous = true
//
//                imageManager.requestImage(for: asset, targetSize: size, contentMode: .aspectFill, options: requestOptions) { image, info in
//                    if let info = info, info["PHImageFileUTIKey"] == nil {
//                        mediaItems.append(image)
//                    }
//                }
//            }
//        }
        
//        let lbImages: [LightboxImage] = allMediaItems.map { lbItem -> LightboxImage in
//            if let assetItem = lbItem as? PHAsset {
//                AssetManager.resolveAssets([assetItem])
//                return LightboxImage(image: AssetManager, text: "", videoURL: )
//            }
//        }
        
        //    let lightboxImages: [LightboxImage] = mediaItems.map { item in
        //      if let image = item as? UIImage {
        //        return LightboxImage(image: image)
        //      }
        //      if let playerItem = item as? AVPlayerItem {
        //        return LightboxImage(image: AssetManager.getImage("video"), text: "VIDEO", videoURL: urlOf(playerItem: playerItem))
        //      }
        //      return LightboxImage(image: AssetManager.getImage("video"))
        //    }
        //
        //    let lightbox = LightboxController(images: lightboxImages, startIndex: 0)
        //    imagePicker.present(lightbox, animated: true, completion: nil)
//    }
    
    func urlOf(playerItem: AVPlayerItem) -> URL? {
        return ((playerItem.asset) as? AVURLAsset)?.url
    }
    
    func doneButtonDidPress(_ imagePicker: ImagePickerController, mediaItems: [PHAsset]) {
        imagePicker.dismiss(animated: true, completion: nil)
    }
}

extension DemoViewController: SimpleGalleryProtocol {
    func cancel(_ container: SimpleGalleryContainer) {
        container.dismiss(animated: true, completion: nil)
    }
    
    func done(_ container: SimpleGalleryContainer, selected: [PHAsset]) {
        container.dismiss(animated: true, completion: nil)
        print(selected)
    }
    
    
}

