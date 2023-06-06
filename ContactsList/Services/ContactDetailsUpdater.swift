//
//  PhoneUpdater.swift
//  ContactsList
//
//  Created by Сергей Матвеенко on 7.06.23.
//

import UIKit

struct ContactDetailsUpdater {
    func updatePhoneNumber(number: String) -> String {
        var numberWithDigitsOnly = number.compactMap { Int(String($0)) }.map { String($0) }
        numberWithDigitsOnly.insert("+", at: 0)
        numberWithDigitsOnly.insert(" (", at: 4)
        numberWithDigitsOnly.insert(") ", at: 7)
        if numberWithDigitsOnly.count > 11 {
            numberWithDigitsOnly.insert("-", at: 11)
        }
        
        if numberWithDigitsOnly.count > 14 {
            numberWithDigitsOnly.insert("-", at: 14)
        }
        
        let updatedNumber = numberWithDigitsOnly.joined()
        return updatedNumber
    }
    
    func prepareImage(contactImageData: Data?) -> UIImage {
        guard let stockImage = UIImage(systemName: "person.crop.circle") else { return UIImage() }
        
        if let imageData = contactImageData {
            if let image = UIImage(data: imageData) {
                return image
            } else {
                return stockImage
            }
        } else {
            return stockImage
        }
    }
}
