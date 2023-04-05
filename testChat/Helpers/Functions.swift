//
//  Functions.swift
//  testChat
//
//  Created by Artour Ilyasov on 29.03.2023.
//

import PhoneNumberKit

func format(_ phoneNumber: String) -> String {
    let phoneNumberKit = PhoneNumberKit()
    do {
        let phoneNumber = try phoneNumberKit.parse(phoneNumber)
        let formattedString = phoneNumberKit.format(phoneNumber, toType: .international)
        return formattedString
    } catch {
        print(error.localizedDescription)
        return ""
    }
}

func getDate(_ stringDate: String) -> Date {
    let dateFormatter = DateFormatter()
    dateFormatter.dateFormat = "yyyy-MM-dd"
    guard let dateOfBirth = dateFormatter.date(from: stringDate) else { return Date() }
    
    return dateOfBirth
}

func getDate(_ date: Date) -> String {
    let dateFormatter = DateFormatter()
    dateFormatter.dateFormat = "yyyy-MM-dd"
    
    return dateFormatter.string(from: date)
}


