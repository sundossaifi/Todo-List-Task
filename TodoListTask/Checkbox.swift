
import UIKit

protocol CheckboxDelegate {
    func checkboxTapped(checkbox:Checkbox, isChecked:Bool)
}

class Checkbox: UIButton {
    
    var delegate: CheckboxDelegate?
    
    private var image: UIImage {
        return checked ? UIImage(systemName: "checkmark.square.fill")! : UIImage(systemName: "square")!
    }
    
    public var checked: Bool = false {
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
            self?.buttonChecked()}), for: .touchUpInside)
    }
    
    func buttonChecked() {
        self.checked.toggle()
        self.delegate?.checkboxTapped(checkbox:self, isChecked:self.checked)
        sendActions(for: .valueChanged)
    }
    
}
