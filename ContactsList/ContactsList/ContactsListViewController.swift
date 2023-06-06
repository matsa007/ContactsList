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
    
    // MARK: - Lifecycle

    override func viewDidLoad() {
        super.viewDidLoad()
        self.checkContactsAccessAndAsk()
        self.view.backgroundColor = .green
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
        }
    }
}

