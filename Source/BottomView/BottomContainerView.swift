import UIKit

protocol BottomContainerViewDelegate: class {

  func pickerButtonDidPress()
  func pickerVideoButtonDidPress()
  func doneButtonDidPress()
  func cancelButtonDidPress()
  func imageStackViewDidPress()
  func switchCameraModeDidPress()

}

open class BottomContainerView: UIView {

  enum CameraMode: Int {
    case photo
    case video
    //        case stream
  }

  struct Dimensions {
    static let height: CGFloat = 101
  }

  var configuration = Configuration()
  var currentCameraModeIndex: CameraMode = .photo
  let cameraModeTitles = ["Photo", "Video"]

  lazy var pickerButton: ButtonPicker = { [unowned self] in
    let pickerButton = ButtonPicker(configuration: self.configuration)
    pickerButton.setTitleColor(UIColor.white, for: UIControlState())
    pickerButton.delegate = self
    pickerButton.numberLabel.isHidden = !self.configuration.showsImageCountLabel

    return pickerButton
    }()

  lazy var pickerVideoButton: ButtonVideoPicker = { [unowned self] in
    let pickerVideoButton = ButtonVideoPicker(configuration: self.configuration)
    pickerVideoButton.setTitleColor(UIColor.white, for: UIControlState())
    pickerVideoButton.delegate = self
    pickerVideoButton.numberLabel.isHidden = !self.configuration.showsImageCountLabel

    return pickerVideoButton
    }()

  lazy var borderPickerButton: UIView = {
    let view = UIView()
    view.backgroundColor = UIColor.clear
    view.layer.borderColor = UIColor.white.cgColor
    view.layer.borderWidth = ButtonPicker.Dimensions.borderWidth
    view.layer.cornerRadius = ButtonPicker.Dimensions.buttonBorderSize / 2

    return view
  }()

  open lazy var doneButton: UIButton = { [unowned self] in
    let button = UIButton()
    button.setTitle(self.configuration.cancelButtonTitle, for: UIControlState())
    button.titleLabel?.font = self.configuration.doneButton
    button.addTarget(self, action: #selector(doneButtonDidPress(_:)), for: .touchUpInside)
    button.titleLabel?.textAlignment = .center

    return button
    }()

  open lazy var switchCameraModeButton: UIButton = { [unowned self] in
    let button = UIButton()
    button.accessibilityLabel = ""
    button.accessibilityHint = "Double-tap to switch camera mode"
    button.setTitle(cameraModeTitles.first, for: UIControlState())
    button.titleLabel?.font = self.configuration.doneButton
    //        button.setImage(AssetManager.getImage("cameraIcon"), for: UIControlState())
    button.addTarget(self, action: #selector(switchCameraModeButtonDidPress(_:)), for: .touchUpInside)
    //        button.imageView?.contentMode = .center
    button.titleLabel?.textAlignment = .center

    return button
    }()

  lazy var stackView = ImageStackView(frame: CGRect(x: 0, y: 0, width: 80, height: 80))

  lazy var topSeparator: UIView = { [unowned self] in
    let view = UIView()
    view.backgroundColor = self.configuration.backgroundColor

    return view
    }()

  lazy var tapGestureRecognizer: UITapGestureRecognizer = { [unowned self] in
    let gesture = UITapGestureRecognizer()
    gesture.addTarget(self, action: #selector(handleTapGestureRecognizer(_:)))

    return gesture
    }()

  weak var delegate: BottomContainerViewDelegate?
  var pastCount = 0

  // MARK: Initializers

  public init(configuration: Configuration? = nil) {
    if let configuration = configuration {
      self.configuration = configuration
    }
    super.init(frame: .zero)
    configure()
  }

  public required init?(coder aDecoder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }

  func configure() {
    [borderPickerButton, pickerButton, pickerVideoButton, switchCameraModeButton, doneButton, stackView, topSeparator].forEach {
      addSubview($0)
      $0.translatesAutoresizingMaskIntoConstraints = false
    }

    backgroundColor = configuration.backgroundColor
    stackView.accessibilityLabel = "Image stack"
    stackView.addGestureRecognizer(tapGestureRecognizer)

    setupConstraints()
  }

  // MARK: - Action methods

  @objc func doneButtonDidPress(_ button: UIButton) {
    if button.currentTitle == configuration.cancelButtonTitle {
      delegate?.cancelButtonDidPress()
    } else {
      delegate?.doneButtonDidPress()
    }
  }

  @objc func handleTapGestureRecognizer(_ recognizer: UITapGestureRecognizer) {
    delegate?.imageStackViewDidPress()
  }

  @objc func switchCameraModeButtonDidPress(_ button: UIButton) {
    var index = currentCameraModeIndex.rawValue
    index += 1
    index = index % cameraModeTitles.count

    //        switch currentCameraModeIndex {
    //        case 1:
    //            button.setTitleColor(UIColor(red: 0.98, green: 0.98, blue: 0.45, alpha: 1), for: UIControlState())
    //            button.setTitleColor(UIColor(red: 0.52, green: 0.52, blue: 0.24, alpha: 1), for: .highlighted)
    //
    //        default:
    //            button.setTitleColor(UIColor.white, for: UIControlState())
    //            button.setTitleColor(UIColor.white, for: .highlighted)
    //        }

    currentCameraModeIndex = CameraMode(rawValue: index)!
    let newTitle = cameraModeTitles[currentCameraModeIndex.rawValue]

    //        button.setImage(AssetManager.getImage(newTitle), for: UIControlState())
    button.setTitle(newTitle, for: UIControlState())
    button.accessibilityLabel = "Camera mode is \(newTitle)"

    delegate?.switchCameraModeDidPress()
  }

  fileprivate func animateImageView(_ imageView: UIImageView) {
    imageView.transform = CGAffineTransform(scaleX: 0, y: 0)

    UIView.animate(withDuration: 0.3, animations: {
      imageView.transform = CGAffineTransform(scaleX: 1.05, y: 1.05)
    }, completion: { _ in
      UIView.animate(withDuration: 0.2, animations: {
        imageView.transform = CGAffineTransform.identity
      })
    })
  }
}

// MARK: - ButtonPickerDelegate methods

extension BottomContainerView: ButtonPickerDelegate {

  func buttonDidPress() {
    delegate?.pickerButtonDidPress()
  }
}

extension BottomContainerView: ButtonVideoPickerDelegate {

  func buttonVideoDidPress() {
    delegate?.pickerVideoButtonDidPress()
  }
}
