//
//  ContactAddingViewController.swift
//  ContactsList
//
//  Created by Сергей Матвеенко on 9.06.23.
//

import UIKit

final class ContactAddingViewController: ContactEditingViewController {
    
    var valueChangeHandler: ((DisplayData) -> ())?
    
    private let updater = ContactDetailsUpdater()
    var ppp = ""
    
    @objc override func editingDoneTapped() {
        self.valueChangeHandler?(DisplayData(firstName: self.firstNameTextField.text ?? "", lastName: self.lastNameTextField.text ?? "", organizationName: self.organizationNameTextField.text ?? "", contactImage: self.contactImageView.image ?? updater.prepareImage(contactImageData: nil), phones: [self.ppp], emails: [""]))
        
        super.editingDoneTapped()
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "contact_editing_cell", for: indexPath) as? ContactEditingTableViewCell else { return UITableViewCell() }
        print(cell.dataTextField.text)
        cell.closure = { [weak self] tag, phone in
            guard let self else { return }
            self.ppp = phone
            print("phone = \(phone)")
            print("!!!!! = \(self.ppp)")
            
        }
        print("HERE")
        return cell
//        return super.tableView(tableView, cellForRowAt: indexPath)
    }
}
