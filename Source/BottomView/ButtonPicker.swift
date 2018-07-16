import UIKit

protocol ButtonPickerDelegate: class {
    
    func buttonDidPress()
}

class ButtonPicker: UIButton {
    
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
    
    weak var delegate: ButtonPickerDelegate?
    
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
        backgroundColor = UIColor.init(red: 245/255, green: 51/255, blue: 51/255, alpha: 1)
        layer.cornerRadius = Dimensions.buttonSize / 2
        accessibilityLabel = "Take photo"
        addTarget(self, action: #selector(pickerButtonDidPress(_:)), for: .touchUpInside)
        addTarget(self, action: #selector(pickerButtonDidHighlight(_:)), for: .touchDown)
    }
    
    // MARK: - Actions
    
    @objc func pickerButtonDidPress(_ button: UIButton) {
        backgroundColor = UIColor.init(red: 245/255, green: 51/255, blue: 51/255, alpha: 1)
        numberLabel.textColor = UIColor.black
        numberLabel.sizeToFit()
        delegate?.buttonDidPress()
    }
    
    @objc func pickerButtonDidHighlight(_ button: UIButton) {
        numberLabel.textColor = UIColor.white
        backgroundColor = UIColor(red: 0.3, green: 0.3, blue: 0.3, alpha: 0.9)
    }
}
