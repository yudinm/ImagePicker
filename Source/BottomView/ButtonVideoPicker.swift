import UIKit

protocol ButtonVideoPickerDelegate: class {

    func buttonVideoDidPress()
}

class ButtonVideoPicker: UIButton {

    struct Dimensions {
        static let borderWidth: CGFloat = 2
        static let buttonSize: CGFloat = 58
        static let buttonBorderSize: CGFloat = 68
    }

    var configuration = Configuration()

    lazy var numberLabel: UILabel = { [unowned self] in
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = self.configuration.numberLabelFont

        return label
        }()

    weak var delegate: ButtonVideoPickerDelegate?
    var recording: Bool = false

    // MARK: - Initializers

    public init(configuration: Configuration? = nil) {
        if let configuration = configuration {
            self.configuration = configuration
        }
        super.init(frame: .zero)
        configure()
    }

    override init(frame: CGRect) {
        super.init(frame: frame)
        configure()
    }

    func configure() {
        addSubview(numberLabel)

        subscribe()
        setupButton()
        setupConstraints()
    }

    deinit {
        NotificationCenter.default.removeObserver(self)
    }

    func subscribe() {
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(recalculatePhotosCount(_:)),
                                               name: NSNotification.Name(rawValue: ImageStack.Notifications.imageDidPush),
                                               object: nil)

        NotificationCenter.default.addObserver(self,
                                               selector: #selector(recalculatePhotosCount(_:)),
                                               name: NSNotification.Name(rawValue: ImageStack.Notifications.imageDidDrop),
                                               object: nil)

        NotificationCenter.default.addObserver(self,
                                               selector: #selector(recalculatePhotosCount(_:)),
                                               name: NSNotification.Name(rawValue: ImageStack.Notifications.stackDidReload),
                                               object: nil)
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: - Configuration

    func setupButton() {
        backgroundColor = UIColor.red.withAlphaComponent(0.9)
        layer.cornerRadius = Dimensions.buttonSize / 2
        accessibilityLabel = "Start recording"
        addTarget(self, action: #selector(pickerVideoButtonDidPress(_:)), for: .touchUpInside)
        addTarget(self, action: #selector(pickerVideoButtonDidHighlight(_:)), for: .touchDown)
    }

    // MARK: - Actions

    @objc func recalculatePhotosCount(_ notification: Notification) {
        guard let sender = notification.object as? ImageStack else { return }
        numberLabel.text = sender.assets.isEmpty ? "" : String(sender.assets.count)
    }

    @objc func pickerVideoButtonDidPress(_ button: UIButton) {
        recording = !recording
        if recording {
            accessibilityLabel = "Stop recording"
            backgroundColor = UIColor.red.withAlphaComponent(0.6)
        } else {
            accessibilityLabel = "Start recording"
            backgroundColor = UIColor.red.withAlphaComponent(0.9)
        }
        numberLabel.textColor = UIColor.black
        numberLabel.sizeToFit()
        delegate?.buttonVideoDidPress()
    }

    @objc func pickerVideoButtonDidHighlight(_ button: UIButton) {
        numberLabel.textColor = UIColor.white
        backgroundColor = UIColor(red: 0.3, green: 0.3, blue: 0.3, alpha: 1)
    }
}
