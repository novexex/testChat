//
//  File.swift
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
    let url = URL(string: "https://plannerok.ru/api/v1/users/check-auth-code/")!
    var request = URLRequest(url: url)
    request.httpMethod = "POST"
    let body: [String: Any] = ["phone": phoneNumber, "code": code]
    request.httpBody = try? JSONSerialization.data(withJSONObject: body, options: [])
    request.setValue("application/json", forHTTPHeaderField: "Content-Type")
    URLSession.shared.dataTask(with: request) { data, response, error in
        if let error = error {
            print("Error: \(error)")
            return
        }
        guard let data = data, let response = response as? HTTPURLResponse else {
            print("Invalid data or response")
            return
        }
        if response.statusCode == 200 {
            // успешный запрос, получаем данные
            guard let jsonData = try? JSONSerialization.jsonObject(with: data, options: []) as? [String: Any] else {
                print("Invalid data format")
                return
            }
            let refreshToken = jsonData["refresh_token"] as? String
            let accessToken = jsonData["access_token"] as? String
//            let userId = jsonData["user_id"] as? Int
            let isUserExists = jsonData["is_user_exists"] as? Bool
            if isUserExists == true {
                completion(true)
                
                UserDefaults.standard.string(forKey: "refresh_token")
                UserDefaults.standard.set(refreshToken, forKey: "refresh_token")
                
                UserDefaults.standard.string(forKey: "access_token")
                UserDefaults.standard.set(accessToken, forKey: "access_token")
            } else {
                completion(false)
            }
        } else {
            // ошибка при запросе
            print("Status code: \(response.statusCode)")
        }
    }.resume()
}

func registerUser(_ phone: String, _ name: String, _ username: String, completion: @escaping (Int) -> Void) {
    // Создание URL из строки
    let url = URL(string: "https://plannerok.ru/api/v1/users/register/")!
    
    // Создание запроса
    var request = URLRequest(url: url)
    request.httpMethod = "POST"
    
    // Создание тела запроса из параметров
    let parameters = [
        "phone": phone,
        "name": name,
        "username": username
    ]
    request.httpBody = try? JSONSerialization.data(withJSONObject: parameters)
    
    // Установка заголовков запроса
    request.setValue("application/json", forHTTPHeaderField: "Content-Type")
    
    // Отправка запроса
    URLSession.shared.dataTask(with: request) { (data, response, error) in
        if let error = error {
            print("Error: \(error)")
            return
        }
        guard let response = response as? HTTPURLResponse else {
            print("Invalid data or response")
            return
        }
        if response.statusCode == 201 {
            print("User successfuly registered")
            completion(response.statusCode)
        } else {
            print("Status code: \(response.statusCode)")
            completion(response.statusCode)
        }
    }.resume()
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


