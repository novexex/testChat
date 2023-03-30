//
//  UserEntity.swift
//  testChat
//
//  Created by Artour Ilyasov on 30.03.2023.
//

import Foundation

struct User {
    var name: String
    var city: String
    var phone: String
    var dateOfBirth: Date
    var aboutMe: String    
    
    var zodiacSign: String {
        let calendar = Calendar.current
        let month = calendar.component(.month, from: dateOfBirth)
        let day = calendar.component(.day, from: dateOfBirth)
        switch month {
        case 1:
            return day <= 19 ? "Capricorn" : "Aquarius"
        case 2:
            return day <= 18 ? "Aquarius" : "Fish"
        case 3:
            return day <= 20 ? "Fish" : "Aries"
        case 4:
            return day <= 19 ? "Aries" : "Taurus"
        case 5:
            return day <= 20 ? "Taurus" : "Gemini"
        case 6:
            return day <= 20 ? "Gemini" : "Cancer"
        case 7:
            return day <= 22 ? "Cancer" : "Leo"
        case 8:
            return day <= 22 ? "Leo" : "Virgo"
        case 9:
            return day <= 22 ? "Virgo" : "Scales"
        case 10:
            return day <= 22 ? "Scales" : "Scorpio"
        case 11:
            return day <= 21 ? "Scorpio" : "Sagittarius"
        case 12:
            return day <= 21 ? "Sagittarius" : "Capricorn"
        default:
            return ""
        }
    }
}
