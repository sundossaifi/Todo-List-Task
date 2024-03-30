import UIKit

protocol TodoTableViewCellDelegate {
    func deleteButtonTapped(indexPath: IndexPath)
}

class TodoTableViewCell: UITableViewCell {
    
    private lazy var taskCheckbox: Checkbox = {
        let taskCheckbox = Checkbox()
        taskCheckbox.translatesAutoresizingMaskIntoConstraints = false
        return taskCheckbox
    }()
    
    private lazy var taskLabel: UILabel = {
        let taskLabel = UILabel()
        taskLabel.translatesAutoresizingMaskIntoConstraints = false
        taskLabel.numberOfLines = 0
        return taskLabel
    }()
    
    private lazy var deleteButton: UIButton = {
        let deleteButton = UIButton()
        deleteButton.translatesAutoresizingMaskIntoConstraints = false
        deleteButton.setBackgroundImage(UIImage(systemName: "minus.circle.fill"), for: .normal)
        deleteButton.layer.cornerRadius = 10
        deleteButton.tintColor = .systemRed
        deleteButton.addAction(UIAction(handler:{ [weak self] _ in
            guard let indexPath = self?.indexPath else{
                return
            }
            self?.delegate?.deleteButtonTapped(indexPath: indexPath)
        }), for: .touchUpInside)
        return deleteButton
    }()
    
    private lazy var cellStackView: UIStackView = {
        let cellStackView = UIStackView()
        cellStackView.translatesAutoresizingMaskIntoConstraints = false
        cellStackView.axis = .horizontal
        cellStackView.distribution = .equalSpacing
        cellStackView.spacing = 4
        cellStackView.alignment = .center
        return cellStackView
    }()
    
    var delegate: TodoTableViewCellDelegate?
    
    static let identifier = "TodoTableViewCell"
    
    var indexPath: IndexPath?
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        taskCheckbox.delegate = self
        setupCellConstraints()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setupCellConstraints()
    }
    
    func setupCellConstraints() {
        contentView.addSubview(cellStackView)
        
        NSLayoutConstraint.activate([
            cellStackView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 20),
            cellStackView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -20),
            cellStackView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 10),
            cellStackView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -10),
            
            taskCheckbox.widthAnchor.constraint(equalToConstant: 25),
            taskCheckbox.heightAnchor.constraint(equalToConstant: 25),
        ])
        cellStackView.addArrangedSubview(deleteButton)
        cellStackView.addArrangedSubview(taskLabel)
        cellStackView.addArrangedSubview(taskCheckbox)
        deleteButton.isHidden = true
    }
    
    func configureCell (title: String, checked: Bool, indexPath: IndexPath) {
        taskLabel.text = title
        taskCheckbox.isChecked = checked
        self.indexPath = indexPath
    }
    
    func toggleDeleteButtonVisiblity(isEditing :Bool) {
        UIView.animate(withDuration: 0.3) {
            self.deleteButton.isHidden = !isEditing
        }
    }
}

extension TodoTableViewCell: CheckboxDelegate {
    func checkboxTapped(isChecked: Bool) {
        if let text = taskLabel.text {
            let attributedString = NSMutableAttributedString(string: text)
            
            if isChecked {
                attributedString.addAttribute(.strikethroughStyle, value: 2, range: NSRange(location: 0, length: attributedString.length))
            } else {
                attributedString.removeAttribute(.strikethroughStyle, range: NSRange(location: 0, length: attributedString.length))
            }
            taskLabel.attributedText = attributedString
        } else {
            taskLabel.attributedText = nil
        }
    }
}

