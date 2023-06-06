//
//  ViewController.swift
//  ContactsList
//
//  Created by Сергей Матвеенко on 6.06.23.
//

import UIKit
import SnapKit
import Contacts

final class ContactsListViewController: UIViewController {
    
    // MARK: - Parameters
    
    private var contactsList = [CNMutableContact]()
    private var displayData = [DisplayData]() {
        didSet {
            DispatchQueue.main.async {
                self.contactsListTableView.reloadData()
            }
        }
    }
    
    // MARK: - GUI
    
    private lazy var contactsListTableView: UITableView = {
        let tableView = UITableView()
        return tableView
    }()
    
    // MARK: - Lifecycle

    override func viewDidLoad() {
        super.viewDidLoad()
        self.checkContactsAccessAndAsk()
        self.fetchContacts()
        self.view.backgroundColor = .white
        self.navigationItem.leftBarButtonItem = UIBarButtonItem(barButtonSystemItem: .edit, target: self, action: #selector(editButtonTapped))
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(addButtonTapped))
        self.navigationItem.title = "Список контактов"
        self.contactsListTableView.delegate = self
        self.contactsListTableView.dataSource = self
        self.contactsListTableView.register(ContactsListTableViewCell.self, forCellReuseIdentifier: "contacts_list_cell")
        self.view.addSubview(self.contactsListTableView)
        self.contactsListTableView.snp.makeConstraints { $0.edges.equalToSuperview() }
    }
    
    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
        self.view.layoutIfNeeded()
    }
    
    // MARK: - Checking access to contacts
    
    private func checkContactsAccessAndAsk() {
        CNContactStore().requestAccess(for: .contacts) { (access, error) in
            switch access {
            case true:
                break
            case false:
                self.alertAddPermissionForContacts("Разрешите доступ к контактам")
            }
        }
    }
    
    // MARK: - Contacts fetching
    
    private func fetchContacts() {
        DispatchQueue.global().async {
            let store = CNContactStore()
            
            store.requestAccess(for: .contacts) { granted, error in
                if granted {
                    let keys = [CNContactGivenNameKey,
                                CNContactFamilyNameKey,
                                CNContactPhoneNumbersKey,
                                CNContactEmailAddressesKey,
                                CNContactImageDataKey,
                                CNContactOrganizationNameKey]
                    
                    let request = CNContactFetchRequest(keysToFetch: keys as [CNKeyDescriptor])
                    do {
                        try store.enumerateContacts(with: request) { contact, _ in
                            let contactDetails = CNMutableContact()
                            contactDetails.imageData = contact.imageData
                            contactDetails.givenName = contact.givenName
                            contactDetails.familyName = contact.familyName
                            contactDetails.organizationName = contact.organizationName
                            contactDetails.phoneNumbers = contact.phoneNumbers
                            contactDetails.emailAddresses = contact.emailAddresses
                            self.contactsList.append(contactDetails)
                        }
                    } catch {
                        self.alertMessage(error.localizedDescription)
                    }
                } else {
                    self.alertAddPermissionForContacts("Разрешите доступ к контактам")
                }
            }
            self.createDisplayData()
        }
    }
    
    private func createDisplayData() {
        let updater = ContactDetailsUpdater()
        self.contactsList.forEach() {
            let phonesInfo = $0.phoneNumbers
            let emailsInfo = $0.emailAddresses
            var phones = [String]()
            var emails = [String]()
            phonesInfo.forEach { phoneNumberDetails in
                phones.append(updater.updatePhoneNumber(number: phoneNumberDetails.value.stringValue))
            }
            
            emailsInfo.forEach { emailDetails in
                emails.append(String(emailDetails.value))
            }
            
            self.displayData.append(DisplayData(firstName: $0.givenName, lastName: $0.familyName, organizationName: $0.organizationName, contactImage: updater.prepareImage(contactImageData: $0.imageData), phones: phones, emails: emails))
        }
    }
}

// MARK: - Extensions

extension ContactsListViewController: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        self.displayData.count
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        60
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "contacts_list_cell", for: indexPath) as? ContactsListTableViewCell else { return UITableViewCell() }
        let contact = self.displayData[indexPath.row]
        cell.setCellView(contactFirstName: contact.firstName, contactLastName: contact.lastName, contactImage: contact.contactImage)
        return cell
    }
}

// MARK: - IBActions

extension ContactsListViewController {
    @objc func editButtonTapped() {
        print("editButtonTapped")
    }
    
    @objc func addButtonTapped() {
        print("addButtonTapped")
        self.contactsListTableView.reloadData()
    }
}

struct DisplayData {
    let firstName: String
    let lastName: String
    let organizationName: String
    let contactImage: UIImage
    let phones: [String]
    let emails: [String]
}
