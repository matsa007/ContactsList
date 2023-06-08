//
//  ContactDetailsViewController.swift
//  ContactsList
//
//  Created by Сергей Матвеенко on 7.06.23.
//

import UIKit

final class ContactDetailsViewController: UIViewController {
    
    // MARK: - Parameters
    
    private let contactDetails: DisplayData
    
    // MARK: - GUI
    
    private lazy var contactImageView: UIImageView = {
        let imageView = UIImageView()
        return imageView
    }()
    
    private lazy var contactFirstAndLastNameLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont(name: "HelveticaNeue-Bold", size: 30)
        label.textAlignment = .center
        return label
    }()
    
    private lazy var organizationNameLabel: UILabel = {
        let label = UILabel()
        label.textAlignment = .center
        label.textColor = .darkGray
        return label
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
        self.navigationItem.leftBarButtonItem = UIBarButtonItem(barButtonSystemItem: .close, target: self, action: #selector(closeButtonTapped))
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .edit, target: self, action: #selector(editButtonTapped))
        self.phonesTableView.dataSource = self
        self.phonesTableView.delegate = self
        self.emailsTableView.dataSource = self
        self.emailsTableView.delegate = self
        self.phonesTableView.register(ContactDetailsTableViewCell.self, forCellReuseIdentifier: "contact_details_cell")
        self.emailsTableView.register(ContactDetailsTableViewCell.self, forCellReuseIdentifier: "contact_details_cell")
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        self.contactImageView.clipsToBounds = true
        self.contactImageView.layer.cornerRadius = self.view.frame.width / 5
        self.addSubViews()
        self.setConstraints()
        self.setContactDetailsView()
    }
    
    // MARK: - Add subviews
    
    private func addSubViews() {
        self.view.addSubview(self.contactImageView)
        self.view.addSubview(self.contactFirstAndLastNameLabel)
        self.view.addSubview(self.organizationNameLabel)
        self.view.addSubview(self.phonesTableView)
        self.view.addSubview(self.emailsTableView)
    }
    
    // MARK: - Constraints
    
    private func setConstraints() {
        self.contactImageView.snp.makeConstraints {
            if let navBar = self.navigationController {
                $0.centerX.equalToSuperview()
                $0.top.equalTo(navBar.navigationBar.snp.bottom)
                $0.width.equalToSuperview().dividedBy(2.5)
                $0.height.equalTo(self.contactImageView.snp.width)
            } else {
                $0.centerX.equalToSuperview()
                $0.top.equalToSuperview()
                $0.width.equalToSuperview().dividedBy(3)
                $0.height.equalTo(self.contactImageView.snp.width)
            }
        }
        
        self.contactFirstAndLastNameLabel.snp.makeConstraints {
            $0.left.right.equalToSuperview()
            $0.top.equalTo(self.contactImageView.snp.bottom)
        }

        self.organizationNameLabel.snp.makeConstraints {
            $0.left.right.equalToSuperview()
            $0.top.equalTo(self.contactFirstAndLastNameLabel.snp.bottom)
        }
        
        self.phonesTableView.snp.makeConstraints {
            $0.top.equalTo(self.organizationNameLabel.snp.bottom).inset(-10)
            $0.left.equalToSuperview().offset(10)
            $0.right.equalToSuperview().offset(-10)
            $0.height.equalTo(self.view.snp.height).dividedBy(4)
        }
        
        self.emailsTableView.snp.makeConstraints {
            $0.top.equalTo(self.phonesTableView.snp.bottom)
            $0.left.equalToSuperview().offset(10)
            $0.right.equalToSuperview().offset(-10)
            $0.height.equalTo(self.view.snp.height).dividedBy(4)
        }
    }
    
    // MARK: - UI updating
    
    private func setContactDetailsView() {
        self.contactImageView.image = self.contactDetails.contactImage
        self.contactFirstAndLastNameLabel.text = "\(self.contactDetails.firstName) \(self.contactDetails.lastName)"
        self.organizationNameLabel.text = self.contactDetails.organizationName
    }
}

// MARK: - Extensions

extension ContactDetailsViewController: UITableViewDataSource, UITableViewDelegate {
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
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "contact_details_cell", for: indexPath) as? ContactDetailsTableViewCell else { return UITableViewCell() }
        switch tableView {
        case self.phonesTableView:
            let phone = self.contactDetails.phones[indexPath.row]
            cell.setCellView(phoneNumberOrEmail: phone)
        case self.emailsTableView:
            let email = self.contactDetails.emails[indexPath.row]
            cell.setCellView(phoneNumberOrEmail: email)
        default:
            break
        }
        return cell
    }
}

// MARK: - IBActions

extension ContactDetailsViewController {
    @objc func closeButtonTapped() {
        self.navigationController?.popViewController(animated: true)
    }
        
    @objc func editButtonTapped() {
        let vc = ContactEditingViewController(contactDetails: self.contactDetails)
        self.navigationController?.pushViewController(vc, animated: true)
    }
}
