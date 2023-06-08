//
//  ContactEditingTableViewCell.swift
//  ContactsList
//
//  Created by Сергей Матвеенко on 8.06.23.
//

import UIKit

final class ContactEditingTableViewCell: UITableViewCell {
    
    // MARK: - Parameters
    
    var closure: ((Int, String) -> ())?
    
    // MARK: - GUI
    
    lazy var dataTextField: UITextField = {
        let textField = UITextField()
        textField.font = UIFont(name: "HelveticaNeue", size: 17)
        textField.textAlignment = .left
        textField.backgroundColor = UIColor(red: 230/255, green: 230/255, blue: 230/255, alpha: 1)
        textField.isUserInteractionEnabled = true
        textField.resignFirstResponder()
        return textField
    }()
    
    // MARK: - Lifecycle

    override func layoutSubviews() {
        super.layoutSubviews()
        self.addSubViews()
        self.setConstraints()
        self.dataTextField.delegate = self
    }
        
    override func prepareForReuse() {
        super.prepareForReuse()
        self.dataTextField.text = nil
    }
    
    // MARK: - Add subviews
    
    private func addSubViews() {
        self.contentView.addSubview(self.dataTextField)
    }
    
    // MARK: - Constraints
    
    private func setConstraints() {
        self.dataTextField.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }
    }
    
    // MARK: - Set cell view
    
    func setCellView(phoneNumberOrEmail: String) {
        self.dataTextField.text = phoneNumberOrEmail
    }
}

// MARK: - Extensions

extension ContactEditingTableViewCell: UITextFieldDelegate {
    func textFieldDidEndEditing(_ textField: UITextField) {
        let tag = textField.tag
        self.closure?(tag, self.dataTextField.text ?? "")
    }
}
