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
}

