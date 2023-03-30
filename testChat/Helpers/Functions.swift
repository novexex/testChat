//
//  Functions.swift
//  testChat
//
//  Created by Artour Ilyasov on 29.03.2023.
//

import Foundation

func countryFlag(_ countryCode: String) -> String {
    let flagBase = UnicodeScalar("🇦").value - UnicodeScalar("A").value
    let flag = countryCode
        .uppercased()
        .unicodeScalars
        .compactMap({ UnicodeScalar(flagBase + $0.value)?.description })
        .joined()
    
    return flag
}

func checkAuthCode(_ phoneNumber: String, _ code: String, completion: @escaping (Bool) -> Void) {
    guard let url = URL(string: "https://plannerok.ru/api/v1/users/check-auth-code/") else { return }
    var request = URLRequest(url: url)
    request.httpMethod = "POST"
    let body = [
        "phone": phoneNumber,
        "code": code
    ]
    request.httpBody = try? JSONSerialization.data(withJSONObject: body)
    request.setValue("application/json", forHTTPHeaderField: "Content-Type")
    URLSession.shared.dataTask(with: request) { data, response, error in
        if let error = error {
            print("Error: \(error)")
            return
        }
        guard let data, let response = response as? HTTPURLResponse else {
            print("Invalid data or response")
            return
        }
        if response.statusCode == 200 { // successs response
            guard let jsonData = try? JSONSerialization.jsonObject(with: data, options: []) as? [String: Any] else {
                print("Invalid data format")
                return
            }
            let refreshToken = jsonData["refresh_token"] as? String
            let accessToken = jsonData["access_token"] as? String
            let isUserExists = jsonData["is_user_exists"] as? Bool
            if isUserExists == true { // user is registered
                saveTokens(refreshToken, accessToken)
                completion(true)
            } else { // user is not registered
                completion(false)
            }
        } else { // error response
            print("Status code: \(response.statusCode)")
        }
    }.resume()
}

func registerUser(_ phone: String, _ name: String, _ username: String, completion: @escaping (Int) -> Void) {
    guard let url = URL(string: "https://plannerok.ru/api/v1/users/register/") else { return }
    var request = URLRequest(url: url)
    request.httpMethod = "POST"
    let body = [
        "phone": phone,
        "name": name,
        "username": username
    ]
    request.httpBody = try? JSONSerialization.data(withJSONObject: body)
    request.setValue("application/json", forHTTPHeaderField: "Content-Type")
    URLSession.shared.dataTask(with: request) { (data, response, error) in
        if let error = error {
            print("Error: \(error)")
            return
        }
        guard let data, let response = response as? HTTPURLResponse else {
            print("Invalid data or response")
            return
        }
        if response.statusCode == 201 { // successs response
            guard let jsonData = try? JSONSerialization.jsonObject(with: data, options: []) as? [String: Any] else {
                print("Invalid data format")
                return
            }
            let refreshToken = jsonData["refresh_token"] as? String
            let accessToken = jsonData["access_token"] as? String
            saveTokens(refreshToken, accessToken)
            
            print("User successfuly registered")
            completion(response.statusCode)
        } else { // error response
            print("Status code: \(response.statusCode)")
            completion(response.statusCode)
        }
    }.resume()
}

func saveTokens(_ refreshToken: String?, _ accessToken: String?) {
    UserDefaults.standard.set(refreshToken, forKey: "refresh_token")
    UserDefaults.standard.set(accessToken, forKey: "access_token")
}

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

func getZodiacSign(_ stringDate: String) -> String {
    let dateFormatter = DateFormatter()
    dateFormatter.dateFormat = "yyyy-MM-dd"
    guard let dateOfBirth = dateFormatter.date(from: stringDate) else { return "" }
    
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
