import UIKit

protocol ButtonVideoPickerDelegate: class {

    func buttonVideoDidPress()
}

class ButtonVideoPicker: UIButton {

    struct Dimensions {
        static let borderWidth: CGFloat = 6
        static let buttonSize: CGFloat = 46
        static let buttonBorderSize: CGFloat = 66
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

        setupButton()
        setupConstraints()
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

    @objc func pickerVideoButtonDidPress(_ button: UIButton) {
        recording = !recording
        if recording {
            accessibilityLabel = "Stop recording"
            numberLabel.text = "Stop"
            backgroundColor = UIColor.red.withAlphaComponent(0.8)
        } else {
            accessibilityLabel = "Start recording"
            numberLabel.text = ""
            backgroundColor = UIColor.red.withAlphaComponent(0.9)
        }
        numberLabel.textColor = UIColor.white.withAlphaComponent(0.8)
        numberLabel.sizeToFit()
        delegate?.buttonVideoDidPress()
    }

    @objc func pickerVideoButtonDidHighlight(_ button: UIButton) {
        numberLabel.textColor = UIColor.white
        backgroundColor = UIColor(red: 0.3, green: 0.3, blue: 0.3, alpha: 1)
    }
}
