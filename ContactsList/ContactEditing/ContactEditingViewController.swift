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
    
    // MARK: - Initialization
    
    init(contactDetails: DisplayData) {
        self.contactDetails = contactDetails
        super.init()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = .yellow

    }

}
