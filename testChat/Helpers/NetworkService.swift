//
//  NetworkService.swift
//  testChat
//
//  Created by Artour Ilyasov on 31.03.2023.
//

import Foundation

class NetworkService {
    static func checkAuthCode(_ phoneNumber: String, _ code: String, completion: @escaping (Bool) -> Void) {
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
                    self.saveTokens(refreshToken, accessToken)
                    completion(true)
                } else { // user is not registered
                    completion(false)
                }
            } else { // error response
                print("Status code: \(response.statusCode)")
            }
        }.resume()
    }
    
    static func registerUser(_ phone: String, _ name: String, _ username: String, completion: @escaping (Int) -> Void) {
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
                self.saveTokens(refreshToken, accessToken)
                
                print("User successfuly registered")
                completion(response.statusCode)
            } else { // error response
                print("Status code: \(response.statusCode)")
                completion(response.statusCode)
            }
        }.resume()
    }
    
    static func saveTokens(_ refreshToken: String?, _ accessToken: String?) {
        UserDefaults.standard.set(refreshToken, forKey: "refresh_token")
        UserDefaults.standard.set(accessToken, forKey: "access_token")
    }
    
    static func putProfileView(user: UserUpdateRequest) {
        guard let url = URL(string: "https://plannerok.ru/api/v1/users/me/") else { return }
        var request = URLRequest(url: url)
        request.httpMethod = "PUT"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        let bearerToken = NetworkService.getBearerAccessToken()
        request.addValue(bearerToken, forHTTPHeaderField: "Authorization")
        
        do {
            let requestBody = try JSONEncoder().encode(user)
            request.httpBody = requestBody
        } catch {
            print("Error encoding user update request: \(error)")
            return
        }
        
        URLSession.shared.dataTask(with: request) { data, response, error in
            if let error = error {
                print("Error: \(error.localizedDescription)")
                return
            }
            if let httpResponse = response as? HTTPURLResponse, httpResponse.statusCode != 200 { // if not successful response
                print(httpResponse.statusCode)
            }
        }.resume()
    }
    
    static func getBearerAccessToken() -> String {
        guard let accessToken = UserDefaults.standard.string(forKey: "access_token") else { return "" }
        return "Bearer " + accessToken
    }
}
