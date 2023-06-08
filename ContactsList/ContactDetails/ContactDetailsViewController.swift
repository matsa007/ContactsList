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
        self.navigationItem.leftBarButtonItem = UIBarButtonItem(barButtonSystemItem: .close, target: self, action: #selector(closeButtonTapped))
        
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
    }
    
    // MARK: - UI updating
    
    private func setContactDetailsView() {
        self.contactImageView.image = self.contactDetails.contactImage
        self.contactFirstAndLastNameLabel.text = "\(self.contactDetails.firstName) \(self.contactDetails.lastName)"
        self.organizationNameLabel.text = self.contactDetails.organizationName
    }
}

// MARK: - IBActions

extension ContactDetailsViewController {
    @objc func closeButtonTapped() {
        navigationController?.popViewController(animated: true)
    }
}
