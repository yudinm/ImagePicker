import UIKit
import MediaPlayer
import Photos

public protocol ImagePickerDelegate: NSObjectProtocol {
    
    func wrapperDidPress(_ imagePicker: ImagePickerController, capturedMediaItems: [String])
    func doneButtonDidPress(_ imagePicker: ImagePickerController, mediaItems: [String])
    func cancelButtonDidPress(_ imagePicker: ImagePickerController)
}

open class ImagePickerController: UIViewController {
    
    let configuration: Configuration
    
    @IBOutlet weak var cameraView: UIView!
    @IBOutlet weak var btDone: UIButton!
    @IBOutlet weak var vCameraModeContainer: UIView!
    @IBOutlet weak var vPickerButtonContainer: UIView!
    @IBOutlet weak var vLastImageContainer: UIView!
    @IBOutlet weak var ivLastImage: UIImageView!
    @IBOutlet weak var btOpenGallery: UIButton!
    @IBOutlet weak var vLastImageActivityIndicator: UIActivityIndicatorView!
    @IBOutlet weak var vTopPanel: UIView!
    @IBOutlet weak var lblTimeCaptured: UILabel!
    @IBOutlet weak var btFlashMode: UIButton!
    var capturedMedia: [String] = [] {
        didSet {
            if (capturedMedia.count > 0) {
                btDone.setTitle("Done", for: .normal)
                return
            }
            btDone.setTitle("Cancel", for: .normal)
        }
    }
    var seconds: TimeInterval = TimeInterval(0)
    var timer = Timer()
    var lastSwipeIndex = 999
    var currentFlashIndex = 0
    let flashButtonTitles = ["AUTO", "ON", "OFF"]
    
    struct GestureConstants {
        static let maximumHeight: CGFloat = 200
        static let minimumHeight: CGFloat = 125
        static let velocity: CGFloat = 100
    }
    
    open lazy var bottomContainer: BottomContainerView = { [unowned self] in
        let view = BottomContainerView(configuration: self.configuration)
        view.backgroundColor = self.configuration.bottomContainerColor
        view.delegate = self
        view.swipeMenuView.swippableView = cameraController.view
        view.swipeMenuView.delegate = self
        return view
        }()
    
    var cameraController: CameraView!
    
    lazy var volumeView: MPVolumeView = { [unowned self] in
        let view = MPVolumeView()
        view.frame = CGRect(x: 0, y: 0, width: 1, height: 1)
        
        return view
        }()
    
    var volume = AVAudioSession.sharedInstance().outputVolume
    
    open weak var delegate: ImagePickerDelegate?
    open var imageLimit = 0
    open var preferredImageSize: CGSize?
    open var startOnFrontCamera = false
    var totalSize: CGSize { return UIScreen.main.bounds.size }
    var initialFrame: CGRect?
    var initialContentOffset: CGPoint?
    var numberOfCells: Int?
    var statusBarHidden = true
    var isRecordingVideo = false
    fileprivate var isTakingPicture = false
    var player: AVPlayer!
    
    open var doneButtonTitle: String? {
        didSet {
            if let doneButtonTitle = doneButtonTitle {
                bottomContainer.doneButton.setTitle(doneButtonTitle, for: UIControlState())
            }
        }
    }
    
    // MARK: - Initialization
    
    @objc public required init(configuration: Configuration = Configuration()) {
        self.configuration = configuration
        super.init(nibName: nil, bundle: nil)
    }
    
    public override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: Bundle?) {
        self.configuration = Configuration()
        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
    }
    
    public required init?(coder aDecoder: NSCoder) {
        self.configuration = Configuration()
        super.init(coder: aDecoder)
    }
    
    public class func instantinate(configuration: Configuration = Configuration()) -> ImagePickerController {
        let bundle = Bundle(for: AssetManager.self)
        let storyboardName = "ImagePickerController"
        let storyboard = UIStoryboard(name: storyboardName, bundle: bundle)
        let controller = storyboard.instantiateInitialViewController() as! ImagePickerController
        return controller
    }
    
    
    // MARK: - View lifecycle
    
    open override func viewDidLoad() {
        super.viewDidLoad()
        cameraController.delegate = self
        cameraController.startOnFrontCamera = self.startOnFrontCamera

        setupViews()
        setupBinding()
        bottomContainer.swipeMenuView.selectItemAtIndex(index: lastSwipeIndex, animated: false)
    }
    
    func setupViews() {
        view.sendSubview(toBack: volumeView)
        vPickerButtonContainer.addSubview(bottomContainer.borderPickerButton)
        bottomContainer.borderPickerButton.addSubview(bottomContainer.pickerButton)
        bottomContainer.borderPickerButton.addSubview(bottomContainer.pickerVideoButton)
        bottomContainer.pickerButton.translatesAutoresizingMaskIntoConstraints = false
        bottomContainer.pickerVideoButton.translatesAutoresizingMaskIntoConstraints = false
        
        vCameraModeContainer.addSubview(bottomContainer.swipeMenuView)
        bottomContainer.swipeMenuView.delegate = self
        bottomContainer.swipeMenuView.swippableView = bottomContainer.swipeMenuView
        
        let rotate = Helper.getTransform(fromDeviceOrientation: .landscapeRight)
        [bottomContainer.swipeMenuView].forEach {
            $0.transform = rotate
        }
        self.automaticallyAdjustsScrollViewInsets = false
        
        
        for attribute: NSLayoutAttribute in [.left, .top, .right, .bottom] {
            vPickerButtonContainer.addConstraint(NSLayoutConstraint(item: bottomContainer.borderPickerButton, attribute: attribute,
                                                                    relatedBy: .equal, toItem: vPickerButtonContainer, attribute: attribute,
                                                                    multiplier: 1, constant: 0))
        }
        
        for attribute: NSLayoutAttribute in [.left, .top] {
            bottomContainer.borderPickerButton.addConstraint(NSLayoutConstraint(item: bottomContainer.borderPickerButton, attribute: attribute,
                                                                                relatedBy: .equal, toItem: bottomContainer.pickerButton, attribute: attribute,
                                                                                multiplier: 1, constant: -10))
        }
        for attribute: NSLayoutAttribute in [.right, .bottom] {
            bottomContainer.borderPickerButton.addConstraint(NSLayoutConstraint(item: bottomContainer.borderPickerButton, attribute: attribute,
                                                                                relatedBy: .equal, toItem: bottomContainer.pickerButton, attribute: attribute,
                                                                                multiplier: 1, constant: 10))
        }

        for attribute: NSLayoutAttribute in [.left, .top] {
            bottomContainer.borderPickerButton.addConstraint(NSLayoutConstraint(item: bottomContainer.borderPickerButton, attribute: attribute,
                                                                                relatedBy: .equal, toItem: bottomContainer.pickerVideoButton, attribute: attribute,
                                                                                multiplier: 1, constant: -10))
        }
        for attribute: NSLayoutAttribute in [.right, .bottom] {
            bottomContainer.borderPickerButton.addConstraint(NSLayoutConstraint(item: bottomContainer.borderPickerButton, attribute: attribute,
                                                                                relatedBy: .equal, toItem: bottomContainer.pickerVideoButton, attribute: attribute,
                                                                                multiplier: 1, constant: 10))
        }

        
        for attribute: NSLayoutAttribute in [.centerX, .centerY] {
            vCameraModeContainer.addConstraint(NSLayoutConstraint(item: bottomContainer.swipeMenuView, attribute: attribute,
                                                                    relatedBy: .equal, toItem: vCameraModeContainer, attribute: attribute,
                                                                    multiplier: 1, constant: 0))
        }
        vCameraModeContainer.addConstraint(NSLayoutConstraint(item: bottomContainer.swipeMenuView, attribute: .height,
                                                              relatedBy: .equal, toItem: vCameraModeContainer, attribute: .width,
                                                              multiplier: 1, constant: 0))
        vCameraModeContainer.addConstraint(NSLayoutConstraint(item: bottomContainer.swipeMenuView, attribute: .width,
                                                              relatedBy: .equal, toItem: vCameraModeContainer, attribute: .height,
                                                              multiplier: 1, constant: 0))
    }
    
    func updateLastImage(addToCaptured: Bool) {
        vLastImageActivityIndicator.startAnimating()
        AssetManager.fetch(withConfiguration: configuration) { assets in
            guard let lastAsset = assets.first else { return }
            if addToCaptured { self.capturedMedia.append(lastAsset.localIdentifier) }
            AssetManager.resolveAsset(lastAsset, size: CGSize(width: 48, height: 48), shouldPreferLowRes: self.configuration.useLowResolutionPreviewImage) { mediaItem in
                self.vLastImageActivityIndicator.stopAnimating()
                guard mediaItem != nil else { return }
                self.ivLastImage.layer.sublayers?.first?.removeFromSuperlayer()
                if let image = mediaItem as? UIImage {
                    self.ivLastImage.image = image
                }
                if let video = mediaItem as? AVPlayerItem {
                    self.player = AVPlayer(playerItem: video)
                    NotificationCenter.default.addObserver(self,
                                                           selector: #selector(self.playerItemDidReachEnd(notification:)),
                                                           name: Notification.Name.AVPlayerItemDidPlayToEndTime,
                                                           object: self.player?.currentItem)
                    let playerLayer = AVPlayerLayer(player: self.player)
                    self.ivLastImage.layer.addSublayer(playerLayer)
                    playerLayer.frame = self.ivLastImage.bounds
                    playerLayer.videoGravity = .resizeAspectFill
                    self.player.rate = 3.0
                    self.player.isMuted = true
                    self.player.play()
                }
            }
        }
    }
    
    func setupBinding() {
        btDone.addTarget(self, action: #selector(cancelButtonDidPress), for: .touchUpInside)
        btOpenGallery.addTarget(self, action: #selector(openGalleryButtonDidPressed), for: .touchUpInside)
        btFlashMode.addTarget(self, action: #selector(flashButtonDidPress(_:)), for: .touchUpInside)
        let image = btFlashMode.image(for: .normal)
        btFlashMode.tintColor = UIColor.white
        btFlashMode.setImage(image?.withRenderingMode(UIImageRenderingMode.alwaysTemplate), for: .normal)
    }
    
    open override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        if configuration.managesAudioSession {
            _ = try? AVAudioSession.sharedInstance().setActive(true)
        }
        
        statusBarHidden = UIApplication.shared.isStatusBarHidden
        bottomContainer.swipeMenuView.selectItemAtIndex(index: lastSwipeIndex, animated: false)
    }
    
    open override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        updateLastImage(addToCaptured: false)
    }
    
    open override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
        bottomContainer.swipeMenuView.selectItemAtIndex(index: lastSwipeIndex, animated: true)
    }
    
    open override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "embedCameraVC" {
            cameraController = segue.destination as! CameraView
        }
    }
    
    func checkStatus() {
        let currentStatus = PHPhotoLibrary.authorizationStatus()
        guard currentStatus != .authorized else { return }
        
        if currentStatus == .notDetermined { hideViews() }
        
        PHPhotoLibrary.requestAuthorization { (authorizationStatus) -> Void in
            DispatchQueue.main.async {
                if authorizationStatus == .denied {
                    self.presentAskPermissionAlert()
                } else if authorizationStatus == .authorized {
                    self.permissionGranted()
                }
            }
        }
    }
    
    func presentAskPermissionAlert() {
        let alertController = UIAlertController(title: configuration.requestPermissionTitle, message: configuration.requestPermissionMessage, preferredStyle: .alert)
        
        let alertAction = UIAlertAction(title: configuration.OKButtonTitle, style: .default) { _ in
            if let settingsURL = URL(string: UIApplicationOpenSettingsURLString) {
                UIApplication.shared.openURL(settingsURL)
            }
        }
        
        let cancelAction = UIAlertAction(title: configuration.cancelButtonTitle, style: .cancel) { _ in
            self.dismiss(animated: true, completion: nil)
        }
        
        alertController.addAction(alertAction)
        alertController.addAction(cancelAction)
        
        present(alertController, animated: true, completion: nil)
    }
    
    func hideViews() {
        enableGestures(false)
    }
    
    func permissionGranted() {
        enableGestures(true)
    }
    
    // MARK: - Notifications
    
    deinit {
        if configuration.managesAudioSession {
            _ = try? AVAudioSession.sharedInstance().setActive(false)
        }
        
        NotificationCenter.default.removeObserver(self)
    }
    
    func subscribe() {
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(volumeChanged(_:)),
                                               name: NSNotification.Name(rawValue: "AVSystemController_SystemVolumeDidChangeNotification"),
                                               object: nil)
    }
    
    @objc func playerItemDidReachEnd(notification: Notification) {
        if let playerItem: AVPlayerItem = notification.object as? AVPlayerItem {
            playerItem.seek(to: kCMTimeZero, completionHandler: { _ in
                self.player.play()
            })
        }
    }
    
    @objc func volumeChanged(_ notification: Notification) {
        guard configuration.allowVolumeButtonsToTakePicture,
            let slider = volumeView.subviews.filter({ $0 is UISlider }).first as? UISlider,
            let userInfo = (notification as NSNotification).userInfo,
            let changeReason = userInfo["AVSystemController_AudioVolumeChangeReasonNotificationParameter"] as? String, changeReason == "ExplicitVolumeChange" else { return }
        
        slider.setValue(volume, animated: false)
        takePicture()
    }
    
    // MARK: - Helpers
    
    open override var prefersStatusBarHidden: Bool {
        return statusBarHidden
    }
    
    func enableGestures(_ enabled: Bool) {
        bottomContainer.pickerButton.isEnabled = enabled
        bottomContainer.pickerVideoButton.isEnabled = enabled
        bottomContainer.swipeMenuView.isUserInteractionEnabled = enabled
        btFlashMode.isEnabled = enabled
//        topView.rotateCamera.isEnabled = configuration.canRotateCamera
    }
    
    fileprivate func isBelowImageLimit() -> Bool {
        return (imageLimit == 0) // TODO: Check captured images
    }
    
    fileprivate func takePicture() {
        guard isBelowImageLimit() && !isTakingPicture else { return }
        isTakingPicture = true
        enableGestures(false)
        self.cameraController.takePicture {
//            DispatchQueue.main.asyncAfter(deadline: .now() + 0.4, execute: {
            self.isTakingPicture = false
//            })
        }
    }
    
    fileprivate func startRecording() {
        guard isBelowImageLimit() && !isTakingPicture else { endRecording { }; return }
        if #available(iOS 9.0, *) {
            AudioServicesPlaySystemSoundWithCompletion(SystemSoundID(1117), nil)
        } else {
            AudioServicesPlaySystemSound(1117)
        }
        isTakingPicture = true
        self.cameraController.startTakingVideo()
        seconds = TimeInterval(0)
        timer = Timer.scheduledTimer(timeInterval: 1, target: self, selector: (#selector(updateTimer)), userInfo: nil, repeats: true)
    }
    
    @objc func updateTimer() {
        lblTimeCaptured.text = timeString(time: seconds)
        seconds += 1
    }
    
    func timeString(time: TimeInterval) -> String {
        let hours = Int(time) / 3600
        let minutes = Int(time) / 60 % 60
        let seconds = Int(time) % 60
        return String(format:"%02i:%02i:%02i", hours, minutes, seconds)
    }
    
    fileprivate func endRecording(_ completion: @escaping () -> Void) {
        self.timer.invalidate()
        enableGestures(false)
        self.cameraController.stopTakingVideo {
            self.isTakingPicture = false
            completion()
        }
    }
}

// MARK: - Action methods

extension ImagePickerController: BottomContainerViewDelegate {
    
    func pickerButtonDidPress() {
        takePicture()
    }
    
    func pickerVideoButtonDidPress() {
        if !isRecordingVideo {
            startRecording()
        } else {
            endRecording { }
        }
        
        isRecordingVideo = !isRecordingVideo
    }
    
    func doneButtonDidPress() {
        delegate?.doneButtonDidPress(self, mediaItems: capturedMedia)
    }
    
    @objc func cancelButtonDidPress() {
        delegate?.cancelButtonDidPress(self)
    }
    
    @objc func openGalleryButtonDidPressed() {
        delegate?.wrapperDidPress(self, capturedMediaItems: self.capturedMedia)
    }
}

extension ImagePickerController: CameraViewDelegate {
    
    func setFlashButtonHidden(_ hidden: Bool) {
        if configuration.flashButtonAlwaysHidden {
//            topView.flashButton.isHidden = hidden
        }
    }
    
    func imageToLibrary(_ completion: @escaping () -> Void) {
        updateLastImage(addToCaptured: true) // TODO: Fix it right way!
        enableGestures(true)
        completion()
    }
    
    func videoToLibrary(_ completion: @escaping () -> Void) {
        updateLastImage(addToCaptured: true)
        enableGestures(true)
        completion()
    }

    func cameraNotAvailable() {
        btFlashMode.isHidden = true
//        topView.rotateCamera.isHidden = true
        enableGestures(false)
    }
    
}

// MARK: - TopView delegate methods

extension ImagePickerController {

    @objc func flashButtonDidPress(_ button: UIButton) {
        currentFlashIndex += 1
        currentFlashIndex = currentFlashIndex % flashButtonTitles.count
        
        switch currentFlashIndex {
        case 1:
            button.tintColor = UIColor(red: 0.98, green: 0.98, blue: 0.45, alpha: 1)

        case 2:
            button.tintColor = UIColor.lightGray

        default:
            button.tintColor = UIColor.white
        }
        
        let newTitle = flashButtonTitles[currentFlashIndex]
        updateFlashButtonLabel()
        button.accessibilityLabel = "Flash mode is \(newTitle)"
        cameraController.flashCamera(newTitle)
    }
    
    func updateFlashButtonLabel() {
        
        if (lastSwipeIndex == 1) {
            let newTitle = flashButtonTitles[currentFlashIndex]
            lblTimeCaptured.text = newTitle
            lblTimeCaptured.font = UIFont.systemFont(ofSize: 18)
            return
        }
        lblTimeCaptured.text = timeString(time: seconds)
        lblTimeCaptured.font = UIFont.systemFont(ofSize: 26)
    }
//
//    func rotateDeviceDidPress() {
//        cameraController.rotateCamera()
//    }
    
    
}

extension ImagePickerController {
    
    func tryStopRecording(_ completion: @escaping () -> Void) {
        if (self.lastSwipeIndex == 0 && self.isRecordingVideo) {
            self.isRecordingVideo = false
            self.bottomContainer.pickerVideoButton.recording = self.isRecordingVideo
            self.endRecording {
                completion()
            }
            return
        }
        completion()
    }
    
    open override func viewWillTransition(to size: CGSize, with coordinator: UIViewControllerTransitionCoordinator) {
        super.viewWillTransition(to: size, with: coordinator)
//        let isPortrait = size.height > size.width
        tryStopRecording{}
        coordinator.animate(alongsideTransition: { (context) in
            // Small lag on camera mode change.
            self.bottomContainer.swipeMenuView.selectItemAtIndex(index: self.lastSwipeIndex, animated: true)
        }, completion: nil)
    }
}

extension ImagePickerController : SwipeOptionsDelegate {
    
    func didSwipeToItem(_ item: String, index: Int) {

        guard (lastSwipeIndex != index) else { return }
        tryStopRecording {
            self.cameraController.switchCameraMode()
        }
        lastSwipeIndex = index
        let isPickingPhoto = index == 0
        bottomContainer.pickerButton.isHidden = isPickingPhoto
        bottomContainer.pickerVideoButton.isHidden = !isPickingPhoto
//        vTopPanel.isHidden = !isPickingPhoto
        updateFlashButtonLabel()
        
    }
    
}


extension ImagePickerController: SimpleGalleryDelegate {
    
    public func cancel(_ container: SimpleGalleryContainer) {
        container.dismiss(animated: true, completion: nil)
    }
    
    public func done(_ container: SimpleGalleryContainer, selected: [String]) {
        container.dismiss(animated: true, completion: nil)
        self.capturedMedia = selected
        print(selected)
    }
    
}
