//
//  ContactDetailsViewController.swift
//  ContactsList
//
//  Created by Сергей Матвеенко on 7.06.23.
//

import UIKit

final class ContactDetailsViewController: UIViewController {
    
    // MARK: - Lifecycle

    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = .yellow
        self.navigationItem.leftBarButtonItem = UIBarButtonItem(barButtonSystemItem: .close, target: self, action: #selector(closeButtonTapped))
    }

}

// MARK: - IBActions

extension ContactDetailsViewController {
    @objc func closeButtonTapped() {
        navigationController?.popViewController(animated: true)
    }
}
