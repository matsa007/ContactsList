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
    
    private lazy var phonesTableView: UITableView = {
        let table = UITableView()
        return table
    }()
    
    private lazy var emailsTableView: UITableView = {
        let table = UITableView()
        return table
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
        self.view.backgroundColor = .white
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .done, target: self, action: #selector(editingDoneTapped))
        self.navigationItem.title = "Изменение контакта"
        self.firstNameTextField.delegate = self
        self.lastNameTextField.delegate = self
        self.organizationNameTextField.delegate = self
        self.phonesTableView.dataSource = self
        self.phonesTableView.delegate = self
        self.emailsTableView.dataSource = self
        self.emailsTableView.delegate = self
        self.phonesTableView.register(ContactEditingTableViewCell.self, forCellReuseIdentifier: "contact_editing_cell")
        self.emailsTableView.register(ContactEditingTableViewCell.self, forCellReuseIdentifier: "contact_editing_cell")
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
        self.contactEditingScrollView.addSubview(self.phonesTableView)
        self.contactEditingScrollView.addSubview(self.emailsTableView)
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
        
        self.phonesTableView.snp.makeConstraints {
            $0.top.equalTo(self.organizationNameTextField.snp.bottom).offset(10)
            $0.centerX.equalToSuperview()
            $0.width.equalToSuperview().multipliedBy(0.9)
            $0.height.equalToSuperview().dividedBy(4)
        }

        self.emailsTableView.snp.makeConstraints {
            $0.top.equalTo(self.phonesTableView.snp.bottom)
            $0.centerX.equalToSuperview()
            $0.width.equalToSuperview().multipliedBy(0.9)
            $0.height.equalToSuperview().dividedBy(4)
        }
    }
}

// MARK: - Extensions

extension ContactEditingViewController: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
}

extension ContactEditingViewController: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        switch tableView {
        case self.phonesTableView:
            return self.contactDetails.phones.count
        case self.emailsTableView:
            return self.contactDetails.emails.count
        default:
            return 0
        }
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        switch tableView {
        case self.phonesTableView:
            if self.contactDetails.phones.count > 0 {
               return "Телефонные номера:"
            } else { return "" }
        case self.emailsTableView:
            if self.contactDetails.emails.count > 0 {
                return "Электронные почты:"
            } else { return "" }
        default:
            return ""
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "contact_editing_cell", for: indexPath) as? ContactEditingTableViewCell else { return UITableViewCell() }
        
        switch tableView {
        case self.phonesTableView:
            let phone = self.contactDetails.phones[indexPath.row]
            cell.dataTextField.tag = indexPath.row
            cell.setCellView(phoneNumberOrEmail: phone)
        case self.emailsTableView:
            let email = self.contactDetails.emails[indexPath.row]
            cell.dataTextField.tag = indexPath.row
            cell.setCellView(phoneNumberOrEmail: email)
        default:
            break
        }
        return cell
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
