//
//  ContactEditingViewController.swift
//  ContactsList
//
//  Created by Сергей Матвеенко on 8.06.23.
//

import UIKit

final class ContactEditingViewController: UIViewController {
    
    // MARK: - Parameters
    
    private let contactDetails: DisplayData
    
    // MARK: - GUI
    
    private lazy var contactEditingScrollView: UIScrollView = {
        let scrollView = UIScrollView()
        return scrollView
    }()
    
    private lazy var contactImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.image = self.contactDetails.contactImage
        return imageView
    }()
    
    private lazy var editImageButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("Изменить", for: .normal)
        button.addTarget(self, action: #selector(editImageButtonTapped), for: .touchUpInside)
        return button
    }()
    
    private lazy var firstNameTextField: UITextField = {
        let textField = UITextField()
        textField.backgroundColor = UIColor(red: 230/255, green: 230/255, blue: 230/255, alpha: 1)
        textField.attributedPlaceholder = NSAttributedString(string: "Имя", attributes: [NSAttributedString.Key.foregroundColor: UIColor.darkGray])
        textField.text = self.contactDetails.firstName
        textField.isUserInteractionEnabled = true
        textField.resignFirstResponder()
        return textField
    }()
    
    private lazy var lastNameTextField: UITextField = {
        let textField = UITextField()
        textField.backgroundColor = UIColor(red: 230/255, green: 230/255, blue: 230/255, alpha: 1)
        textField.attributedPlaceholder = NSAttributedString(string: "Фамилия", attributes: [NSAttributedString.Key.foregroundColor: UIColor.darkGray])
        textField.text = self.contactDetails.lastName
        textField.isUserInteractionEnabled = true
        textField.resignFirstResponder()
        return textField
    }()
    
    private lazy var organizationNameTextField: UITextField = {
        let textField = UITextField()
        textField.backgroundColor = UIColor(red: 230/255, green: 230/255, blue: 230/255, alpha: 1)
        textField.attributedPlaceholder = NSAttributedString(string: "Организация", attributes: [NSAttributedString.Key.foregroundColor: UIColor.darkGray])
        textField.text = self.contactDetails.organizationName
        textField.text = self.contactDetails.lastName
        textField.isUserInteractionEnabled = true
        return textField
    }()
    
    // MARK: - Initialization
    
    init(contactDetails: DisplayData) {
        self.contactDetails = contactDetails
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = .yellow
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .done, target: self, action: #selector(editingDoneTapped))
        self.navigationItem.title = "Изменение контакта"
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        self.addSubViews()
        self.setConstraints()
        self.contactImageView.clipsToBounds = true
        self.contactImageView.layer.cornerRadius = self.view.frame.width / 5
        self.contactEditingScrollView.layoutIfNeeded()
    }
    
    // MARK: - Add subviews
    
    private func addSubViews() {
        self.view.addSubview(self.contactEditingScrollView)
        self.contactEditingScrollView.addSubview(self.contactImageView)
        self.contactEditingScrollView.addSubview(self.editImageButton)
        self.contactEditingScrollView.addSubview(self.firstNameTextField)
        self.contactEditingScrollView.addSubview(self.lastNameTextField)
        self.contactEditingScrollView.addSubview(self.organizationNameTextField)
    }
    
    // MARK: - Constraints
    
    private func setConstraints() {
        self.contactEditingScrollView.contentSize = self.view.bounds.size
        self.contactEditingScrollView.contentSize.height = self.view.bounds.height*2

        self.contactEditingScrollView.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }
        
        self.contactImageView.snp.makeConstraints {
            $0.centerX.equalToSuperview()
            $0.top.equalTo(self.contactEditingScrollView.snp.top).offset(10)
            $0.width.equalToSuperview().dividedBy(2.5)
            $0.height.equalTo(self.contactImageView.snp.width)
        }
        
        self.editImageButton.snp.makeConstraints {
            $0.centerX.equalToSuperview()
            $0.top.equalTo(self.contactImageView.snp.bottom).offset(10)
        }
        
        self.firstNameTextField.snp.makeConstraints {
            $0.top.equalTo(self.editImageButton.snp.bottom).offset(10)
            $0.centerX.equalToSuperview()
            $0.width.equalToSuperview().multipliedBy(0.9)
            $0.height.equalToSuperview().dividedBy(20)
        }
        
        self.lastNameTextField.snp.makeConstraints {
            $0.top.equalTo(self.firstNameTextField.snp.bottom).offset(10)
            $0.centerX.equalToSuperview()
            $0.width.equalToSuperview().multipliedBy(0.9)
            $0.height.equalToSuperview().dividedBy(20)
        }
        
        self.organizationNameTextField.snp.makeConstraints {
            $0.top.equalTo(self.lastNameTextField.snp.bottom).offset(10)
            $0.centerX.equalToSuperview()
            $0.width.equalToSuperview().multipliedBy(0.9)
            $0.height.equalToSuperview().dividedBy(20)
        }
    }
}

// MARK: - IBActions

extension ContactEditingViewController {
    @objc func editImageButtonTapped() {
        print("editImageButtonTapped")
    }
    
    @objc func editingDoneTapped() {
        print("editingDoneTapped")
    }
}
