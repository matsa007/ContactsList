//
//  ContactsListTableViewCell.swift
//  ContactsList
//
//  Created by Сергей Матвеенко on 6.06.23.
//

import UIKit

final class ContactsListTableViewCell: UITableViewCell {
    
    // MARK: - GUI
    
    private lazy var contactPhotoView: UIView = {
        let view = UIView()
        return view
    }()
    
    private lazy var contactPhotoImageView: UIImageView = {
        let imageView = UIImageView()
        return imageView
    }()
    
    private lazy var firstNameLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont(name: "HelveticaNeue", size: 16)
        label.text = "Имя:"
        return label
    }()
    
    private lazy var lastNameLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont(name: "HelveticaNeue", size: 16)
        label.text = "Фамилия:"
        return label
    }()
    
    private lazy var contactFirstNameLabel: UILabel = {
        let label = UILabel()
        label.textAlignment = .right
        label.font = UIFont(name: "HelveticaNeue-Bold", size: 17)
        return label
    }()
    
    private lazy var contactLastNameLabel: UILabel = {
        let label = UILabel()
        label.textAlignment = .right
        label.font = UIFont(name: "HelveticaNeue-Bold", size: 17)
        return label
    }()
    
    // MARK: - Lifecycle
    
    override func prepareForReuse() {
        super.prepareForReuse()
        
        self.contactPhotoImageView.image = nil
        self.contactFirstNameLabel.text = nil
        self.contactLastNameLabel.text = nil
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        self.addSubViews()
        self.setConstraints()
        self.contactPhotoImageView.clipsToBounds = true
        self.contactPhotoImageView.layer.cornerRadius = self.contactPhotoImageView.frame.height / 2
    }
    
    // MARK: - Add subviews
    
    private func addSubViews() {
        self.contentView.addSubview(self.contactPhotoView)
        self.contactPhotoView.addSubview(self.contactPhotoImageView)
        self.contentView.addSubview(self.firstNameLabel)
        self.contentView.addSubview(self.lastNameLabel)
        self.contentView.addSubview(self.contactFirstNameLabel)
        self.contentView.addSubview(self.contactLastNameLabel)
    }
    
    // MARK: - Constraints
    
    private func setConstraints() {
        self.contactPhotoView.snp.makeConstraints {
            $0.top.bottom.left.equalToSuperview()
            $0.width.equalToSuperview().dividedBy(6)
        }
        
        self.contactPhotoImageView.snp.makeConstraints {
            $0.top.left.equalToSuperview().offset(3)
            $0.bottom.right.equalToSuperview().offset(-3)
        }
                
        self.firstNameLabel.snp.makeConstraints {
            $0.top.equalToSuperview()
            $0.left.equalTo(self.contactPhotoView.snp.right).offset(5)
            $0.height.equalToSuperview().dividedBy(2)
            $0.width.equalToSuperview().dividedBy(6).multipliedBy(2)
        }
        self.lastNameLabel.snp.makeConstraints {
            $0.bottom.equalToSuperview()
            $0.left.equalTo(self.contactPhotoView.snp.right).offset(5)
            $0.height.equalToSuperview().dividedBy(2)
            $0.width.equalToSuperview().dividedBy(6).multipliedBy(2)
        }
        self.contactFirstNameLabel.snp.makeConstraints {
            $0.top.equalToSuperview()
            $0.right.equalToSuperview().offset(-5)
            $0.width.height.equalToSuperview().dividedBy(2)
        }
        self.contactLastNameLabel.snp.makeConstraints {
            $0.bottom.equalToSuperview()
            $0.right.equalToSuperview().offset(-5)
            $0.width.height.equalToSuperview().dividedBy(2)
        }
    }
    
    // MARK: - Set cell view
    
    func setCellView(contactFirstName: String, contactLastName: String, contactImage: UIImage) {
        self.contactPhotoImageView.image = contactImage
        self.contactFirstNameLabel.text = contactFirstName
        self.contactLastNameLabel.text = contactLastName
    }
}
