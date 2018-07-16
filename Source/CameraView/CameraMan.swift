import Foundation
import AVFoundation
import PhotosUI

protocol CameraManDelegate: class {
    func cameraManNotAvailable(_ cameraMan: CameraMan)
    func cameraManDidStart(_ cameraMan: CameraMan)
    func cameraMan(_ cameraMan: CameraMan, didChangeInput input: AVCaptureDeviceInput)
}

class CameraMan: NSObject, AVCaptureFileOutputRecordingDelegate {
    weak var delegate: CameraManDelegate?
    
    let session = AVCaptureSession()
    let queue = DispatchQueue(label: "no.hyper.ImagePicker.Camera.SessionQueue")
    
    var backCamera: AVCaptureDeviceInput?
    var frontCamera: AVCaptureDeviceInput?
    var microphone: AVCaptureDeviceInput?
    var stillImageOutput: AVCaptureStillImageOutput?
    var movieFileOutput: AVCaptureMovieFileOutput?
    var startOnFrontCamera: Bool = false
    var recordingURL: URL?
    var isVideoCapturing: Bool = false {
        didSet {
            
            queue.async {
                if self.isVideoCapturing {
                    self.startVideoCapturing()
                    return
                }
                self.startPhotoCapturing()
            }
        }
    }
    var actionStopTakingVideo: () -> Void = { //_ in
        
    }
    
    deinit {
        stop()
    }
    
    // MARK: - Setup
    
    func setup(_ startOnFrontCamera: Bool = false) {
        self.startOnFrontCamera = startOnFrontCamera
        checkPermission()
    }
    
    func setupDevices() {
        // Input
        AVCaptureDevice
            .devices()
            .filter {
                return $0.hasMediaType(AVMediaType.video)
            }.forEach {
                switch $0.position {
                case .front:
                    self.frontCamera = try? AVCaptureDeviceInput(device: $0)
                case .back:
                    self.backCamera = try? AVCaptureDeviceInput(device: $0)
                default:
                    break
                }
        }
        
        let deviceMicrophone =
            AVCaptureDevice
                .devices()
                .filter {
                    return $0.hasMediaType(AVMediaType.audio)
                }.first
        do {
            if let deviceMicrophone = deviceMicrophone {
                try self.microphone = AVCaptureDeviceInput(device: deviceMicrophone)
            }
        } catch {
            print("\(error.localizedDescription)")
        }
        
        // Output
        stillImageOutput = AVCaptureStillImageOutput()
        stillImageOutput?.outputSettings = [AVVideoCodecKey: AVVideoCodecJPEG]
        // Output Video File
        movieFileOutput = AVCaptureMovieFileOutput()
        
        recordingURL = URL(fileURLWithPath: NSString.path(withComponents: [NSTemporaryDirectory(), "Movie.MOV"]))
        var error:NSError? = nil
        do {
            try FileManager.default.removeItem(at: self.recordingURL!)
        } catch {
            print("\(error.localizedDescription)")
        }
        
    }
    
    func addInput(_ input: AVCaptureDeviceInput) {
        configurePreset(input)
        
        if session.canAddInput(input) {
            session.addInput(input)
            
            DispatchQueue.main.async {
                self.delegate?.cameraMan(self, didChangeInput: input)
            }
        }
    }
    
    // MARK: - Permission
    
    func checkPermission() {
        let status = AVCaptureDevice.authorizationStatus(for: AVMediaType.video)
        
        switch status {
        case .authorized:
            start()
        case .notDetermined:
            requestPermission()
        default:
            delegate?.cameraManNotAvailable(self)
        }
    }
    
    func requestPermission() {
        AVCaptureDevice.requestAccess(for: AVMediaType.video) { granted in
            DispatchQueue.main.async {
                if granted {
                    self.start()
                } else {
                    self.delegate?.cameraManNotAvailable(self)
                }
            }
        }
    }
    
    // MARK: - Session
    
    var currentInput: AVCaptureDeviceInput? {
        return session.inputs.first as? AVCaptureDeviceInput
    }
    
    fileprivate func start() {
        // Devices
        setupDevices()
        
        guard let inputVideo = (self.startOnFrontCamera) ? frontCamera ?? backCamera : backCamera else { return }
        addInput(inputVideo)
        if let inputAudio = self.microphone {
            addInput(inputAudio)
        }
        
        startPhotoCapturing()
        
        queue.async {
            
            self.session.startRunning()
            
            DispatchQueue.main.async {
                self.delegate?.cameraManDidStart(self)
            }
        }
        
    }
    
    private func startVideoCapturing() {
        guard let movieFileOutput = movieFileOutput else { return }
        session.outputs.map { output in session.removeOutput(output) }
        if session.canAddOutput(movieFileOutput) {
            session.addOutput(movieFileOutput)
        }
        recordingURL = URL(fileURLWithPath: NSString.path(withComponents: [NSTemporaryDirectory(), "Movie.MOV"]))
    }
    
    private func startPhotoCapturing() {
        guard let output = stillImageOutput else { return }
        
        session.outputs.map { output in session.removeOutput(output) }
        if session.canAddOutput(output) {
            session.addOutput(output)
        }
    }
    
    private func stop() {
        self.session.stopRunning()
    }
    
    func switchCamera(_ completion: (() -> Void)? = nil) {
        guard let currentInput = currentInput
            else {
                completion?()
                return
        }
        
        queue.async {
            guard let input = (currentInput == self.backCamera) ? self.frontCamera : self.backCamera
                else {
                    DispatchQueue.main.async {
                        completion?()
                    }
                    return
            }
            
            self.configure {
                self.session.removeInput(currentInput)
                self.addInput(input)
            }
            
            DispatchQueue.main.async {
                completion?()
            }
        }
    }
    
    func takePhoto(_ previewLayer: AVCaptureVideoPreviewLayer, location: CLLocation?, completion: (() -> Void)? = nil) {
        guard let connection = stillImageOutput?.connection(with: AVMediaType.video) else { return }
        
        connection.videoOrientation = UIApplication.shared.statusBarOrientation == .landscapeLeft ? .landscapeLeft : .landscapeRight
        
        queue.async {
            self.stillImageOutput?.captureStillImageAsynchronously(from: connection) { buffer, error in
                guard let buffer = buffer, error == nil && CMSampleBufferIsValid(buffer),
                    let imageData = AVCaptureStillImageOutput.jpegStillImageNSDataRepresentation(buffer),
                    let image = UIImage(data: imageData)
                    else {
                        DispatchQueue.main.async {
                            completion?()
                        }
                        return
                }
                
                self.savePhoto(image, location: location, completion: completion)
            }
        }
    }
    
    func savePhoto(_ image: UIImage, location: CLLocation?, completion: (() -> Void)? = nil) {
        PHPhotoLibrary.shared().performChanges({
            let request = PHAssetChangeRequest.creationRequestForAsset(from: image)
            request.creationDate = Date()
            request.location = location
        }, completionHandler: { (_, _) in
            DispatchQueue.main.async {
                completion?()
            }
        })
    }
    
    func startTakingVideo(_ previewLayer: AVCaptureVideoPreviewLayer, location: CLLocation?) {
        guard let connection = movieFileOutput?.connection(with: AVMediaType.video) else { return }
        
        connection.videoOrientation = UIApplication.shared.statusBarOrientation == .landscapeLeft ? .landscapeLeft : .landscapeRight
        
        queue.async {
            guard let movieFileOutput = self.movieFileOutput else { return }
            guard let recordingURL = self.recordingURL else { return }
            do {
                try FileManager.default.removeItem(at: self.recordingURL!)
            } catch {
                print("\(error.localizedDescription)")
            }
            movieFileOutput.startRecording(to: recordingURL, recordingDelegate: self)
        }
    }
    
    func stopTakingVideo() {
        queue.async {
            guard let movieFileOutput = self.movieFileOutput else { return }
            movieFileOutput.stopRecording()
            self.actionStopTakingVideo()
        }
    }
    
    // MARK: - AVCaptureFileOutputRecordingDelegate
    func fileOutput(_ output: AVCaptureFileOutput, didFinishRecordingTo outputFileURL: URL, from connections: [AVCaptureConnection], error: Error?) {
        if let error = error {
            print("\(error.localizedDescription)")
            return
        }
        
        PHPhotoLibrary.shared().performChanges({
            let request = PHAssetChangeRequest.creationRequestForAssetFromVideo(atFileURL: outputFileURL)
            request?.creationDate = Date()
        }, completionHandler: { (_, error) in
            if let error = error {
                print("\(error.localizedDescription)")
                return
            }
            DispatchQueue.main.async {
//                self.delegate?.videoToLibrary {
                    self.actionStopTakingVideo()
//                }
            }
        })
    }
    
    func flash(_ mode: AVCaptureDevice.FlashMode) {
        guard let device = currentInput?.device, device.isFlashModeSupported(mode) else { return }
        
        queue.async {
            self.lock {
                device.flashMode = mode
            }
        }
    }
    
    func focus(_ point: CGPoint) {
        guard let device = currentInput?.device, device.isFocusModeSupported(AVCaptureDevice.FocusMode.locked) else { return }
        
        queue.async {
            self.lock {
                device.focusMode = AVCaptureDevice.FocusMode.autoFocus
                device.exposureMode = AVCaptureDevice.ExposureMode.autoExpose
                device.focusPointOfInterest = point
                device.exposurePointOfInterest = point
            }
        }
    }
    
    func zoom(_ zoomFactor: CGFloat) {
        guard let device = currentInput?.device, device.position == .back else { return }
        
        queue.async {
            self.lock {
                device.videoZoomFactor = zoomFactor
            }
        }
    }
    
    // MARK: - Lock
    
    func lock(_ block: () -> Void) {
        if let device = currentInput?.device, (try? device.lockForConfiguration()) != nil {
            block()
            device.unlockForConfiguration()
        }
    }
    
    // MARK: - Configure
    func configure(_ block: () -> Void) {
        session.beginConfiguration()
        block()
        session.commitConfiguration()
    }
    
    // MARK: - Preset
    
    func configurePreset(_ input: AVCaptureDeviceInput) {
        for asset in preferredPresets() {
            if input.device.supportsSessionPreset(AVCaptureSession.Preset(rawValue: asset)) && self.session.canSetSessionPreset(AVCaptureSession.Preset(rawValue: asset)) {
                self.session.sessionPreset = AVCaptureSession.Preset(rawValue: asset)
                return
            }
        }
    }
    
    func preferredPresets() -> [String] {
        return [
            AVCaptureSession.Preset.high.rawValue,
            AVCaptureSession.Preset.high.rawValue,
            AVCaptureSession.Preset.low.rawValue
        ]
    }
}
