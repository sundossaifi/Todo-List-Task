
import UIKit

protocol CheckboxDelegate {
    func checkboxTapped(isChecked:Bool)
}

class Checkbox: UIButton {
    var delegate: CheckboxDelegate?

    private var image: UIImage? {
        if let image = isChecked ? UIImage(systemName: "checkmark.square.fill") : UIImage(systemName: "square") {
            return image
        } else {
            return nil
        }
    }

    public var isChecked: Bool = false {
        didSet{
            self.setBackgroundImage(image, for: .normal)
        }
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupCheckbox()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setupCheckbox()
    }
    
    func setupCheckbox() {
        self.setBackgroundImage(image, for: .normal)
        self.addAction(UIAction(handler: {  [weak self] _ in
            self?.toggleCheckbox()}), 
            for: .touchUpInside)
    }
    
    func toggleCheckbox() {
        self.isChecked.toggle()
        self.delegate?.checkboxTapped(isChecked:self.isChecked)
        sendActions(for: .valueChanged)
    }
}
