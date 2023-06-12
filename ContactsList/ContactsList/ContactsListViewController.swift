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
    
    private var contactsList = [CNContact]()
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
        self.view.backgroundColor = .white
        self.navigationItem.leftBarButtonItem = UIBarButtonItem(barButtonSystemItem: .edit, target: self, action: #selector(self.editButtonTapped))
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(self.addButtonTapped))
        self.navigationItem.title = "Список контактов"
        self.contactsListTableView.delegate = self
        self.contactsListTableView.dataSource = self
        self.contactsListTableView.register(ContactsListTableViewCell.self, forCellReuseIdentifier: "contacts_list_cell")
        self.view.addSubview(self.contactsListTableView)
        self.contactsListTableView.snp.makeConstraints { $0.edges.equalToSuperview() }
        self.fetchContacts()
    }
    
    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()

        self.view.layoutIfNeeded()
    }
    
    // MARK: - Checking access to contacts
    
    private func checkContactsAccessAndAsk() {
        CNContactStore().requestAccess(for: .contacts) { (access, _) in
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

// MARK: - UITableViewDataSource, UITableViewDelegate

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
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            self.contactsListTableView.beginUpdates()
            self.displayData.remove(at: indexPath.row)
            self.contactsListTableView.deleteRows(at: [indexPath], with: .fade)
            self.contactsListTableView.endUpdates()
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let contact = self.displayData[indexPath.row]
        let vc = ContactDetailsViewController(contactDetails: contact)
        vc.closure = { [weak self] contact in
            guard let self else { return }
            self.displayData[indexPath.row] = contact
        }
        self.navigationController?.pushViewController(vc, animated: true)
    }
}

// MARK: - IBActions

private extension ContactsListViewController {
    @objc func editButtonTapped() {
        switch self.contactsListTableView.isEditing {
        case true:
            self.contactsListTableView.isEditing = false
        case false:
            self.contactsListTableView.isEditing = true
        }
    }
    
    @objc func addButtonTapped() {
        let updater = ContactDetailsUpdater()
        let vc = ContactAddingViewController(contactDetails: DisplayData(firstName: "", lastName: "", organizationName: "", contactImage: updater.prepareImage(contactImageData: nil), phones: [""], emails: [""]))
        vc.valueChangeHandler = { [weak self] contact in
            guard let self else { return }
            dump(contact)
            self.displayData.append(contact)
        }
        self.navigationController?.pushViewController(vc, animated: true)
    }
}
