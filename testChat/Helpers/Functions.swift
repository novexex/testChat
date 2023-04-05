//
//  Functions.swift
//  testChat
//
//  Created by Artour Ilyasov on 29.03.2023.
//

import PhoneNumberKit

func validateName(_ name: String) -> Bool {
    let nameRegEx = "^[a-zA-Z ]*$"
    let nameTest = NSPredicate(format:"SELF MATCHES %@", nameRegEx)
    return nameTest.evaluate(with: name)
}

func validateUsername(_ username: String) -> Bool {
    let usernameRegEx = "^[A-Za-z0-9-_]*$"
    let usernameTest = NSPredicate(format:"SELF MATCHES %@", usernameRegEx)
    return usernameTest.evaluate(with: username)
}

func format(phoneNumber: String) -> String {
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

func getZodiacSign(_ stringDate: String) -> String {
    let dateOfBirth = getDate(stringDate)
    
    let calendar = Calendar.current
    let month = calendar.component(.month, from: dateOfBirth)
    let day = calendar.component(.day, from: dateOfBirth)
    switch month {
    case 1:
        return day <= 19 ? "(Capricorn)" : "(Aquarius)"
    case 2:
        return day <= 18 ? "(Aquarius)" : "(Fish)"
    case 3:
        return day <= 20 ? "(Fish)" : "(Aries)"
    case 4:
        return day <= 19 ? "(Aries)" : "(Taurus)"
    case 5:
        return day <= 20 ? "(Taurus)" : "(Gemini)"
    case 6:
        return day <= 20 ? "(Gemini)" : "(Cancer)"
    case 7:
        return day <= 22 ? "(Cancer)" : "(Leo)"
    case 8:
        return day <= 22 ? "(Leo)" : "(Virgo)"
    case 9:
        return day <= 22 ? "(Virgo)" : "(Scales)"
    case 10:
        return day <= 22 ? "(Scales)" : "(Scorpio)"
    case 11:
        return day <= 21 ? "(Scorpio)" : "(Sagittarius)"
    case 12:
        return day <= 21 ? "(Sagittarius)" : "(Capricorn)"
    default:
        return ""
    }
}
