//
//  ContactDetailsTableViewCell.swift
//  ContactsList
//
//  Created by Сергей Матвеенко on 8.06.23.
//

import UIKit

final class ContactDetailsTableViewCell: UITableViewCell {
    // MARK: - GUI
    
    private lazy var dataLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont(name: "HelveticaNeue-Bold", size: 17)
        label.textAlignment = .left
        return label
    }()
    
    // MARK: - Lifecycle
    
    override func layoutSubviews() {
        super.layoutSubviews()
        self.addSubViews()
        self.setConstraints()
    }
        
    override func prepareForReuse() {
        super.prepareForReuse()
        self.dataLabel.text = nil
    }
    
    // MARK: - Add subviews
    
    private func addSubViews() {
        self.contentView.addSubview(self.dataLabel)
    }
    
    // MARK: - Constraints
    
    private func setConstraints() {
        self.dataLabel.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }
    }
    
    // MARK: - Set cell view
    
    func setCellView(phoneNumberOrEmail: String) {
        self.dataLabel.text = phoneNumberOrEmail
    }
}
