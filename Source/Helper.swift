import UIKit
import AVFoundation

struct Helper {

  static var previousOrientation = UIInterfaceOrientation.unknown
  static var lastOrientation = UIInterfaceOrientation.unknown

  static func getTransform(fromDeviceOrientation orientation: UIInterfaceOrientation) -> CGAffineTransform {
    switch orientation {
    case .landscapeLeft:
      return CGAffineTransform(rotationAngle: CGFloat.pi * 0.5)
    case .landscapeRight:
      return CGAffineTransform(rotationAngle: -(CGFloat.pi * 0.5))
    case .portraitUpsideDown:
      return CGAffineTransform(rotationAngle: CGFloat.pi)
    default:
      return CGAffineTransform.identity
    }
  }

  static func getVideoOrientation(fromDeviceOrientation orientation: UIInterfaceOrientation) -> AVCaptureVideoOrientation {
    switch orientation {
    case .landscapeLeft:
      return .landscapeRight
    case .landscapeRight:
      return .landscapeLeft
    case .portraitUpsideDown:
      return .portraitUpsideDown
    default:
      return .portrait
    }
  }

  static func videoOrientation() -> AVCaptureVideoOrientation {
    return getVideoOrientation(fromDeviceOrientation: previousOrientation)
  }

  static func screenSizeForOrientation() -> CGSize {
    switch UIApplication.shared.statusBarOrientation {
    case .landscapeLeft, .landscapeRight:
      return CGSize(width: UIScreen.main.bounds.height,
                    height: UIScreen.main.bounds.width)
    default:
      return UIScreen.main.bounds.size
    }
  }
}
