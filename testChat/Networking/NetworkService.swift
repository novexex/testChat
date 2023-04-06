//
//  NetworkService.swift
//  testChat
//
//  Created by Artour Ilyasov on 31.03.2023.
//

import Foundation

class NetworkService {
    static func getRequest(url: String) -> URLRequest? {
        guard let url = URL(string: url) else { return nil }
        return URLRequest(url: url)
    }
    
    static func getBearerAccessToken() -> String {
        guard let accessToken = UserDefaults.standard.string(forKey: "access_token") else { return "" }
        return "Bearer " + accessToken
    }
    
    static func getBearerRefreshToken() -> String {
        guard let refreshToken = UserDefaults.standard.string(forKey: "refresh_token") else { return "" }
        return "Bearer " + refreshToken
    }
    
    // TODO: Storing tokens in user defaults is not very secure
    static func saveTokens(_ refreshToken: String?, _ accessToken: String?) {
        UserDefaults.standard.set(refreshToken, forKey: "refresh_token")
        UserDefaults.standard.set(accessToken, forKey: "access_token")
    }
    
    static func checkAuthCode(_ phoneNumber: String, _ code: String, completion: @escaping (Bool) -> Void) {
        guard var request = getRequest(url: "https://plannerok.ru/api/v1/users/check-auth-code/") else { return }
        request.httpMethod = "POST"
        let body = [
            "phone": phoneNumber,
            "code": code
        ]
        request.httpBody = try? JSONSerialization.data(withJSONObject: body)
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        URLSession.shared.dataTask(with: request) { data, response, error in
            if let error {
                print("checkAuthCode")
                print("Error: \(error)")
                return
            }
            guard let data, let response = response as? HTTPURLResponse else {
                print("checkAuthCode")
                print("Invalid data or response")
                return
            }
            if response.statusCode == 200 { // successs response
                guard let jsonData = try? JSONSerialization.jsonObject(with: data, options: []) as? [String: Any] else {
                    print("checkAuthCode")
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
                print("checkAuthCode")
                print("Status code: \(response.statusCode)")
            }
        }.resume()
    }
    
    static func registerUser(_ phone: String, _ name: String, _ username: String, completion: @escaping (Int) -> Void) {
        guard var request = getRequest(url: "https://plannerok.ru/api/v1/users/register/") else { return }
        request.httpMethod = "POST"
        let body = [
            "phone": phone,
            "name": name,
            "username": username
        ]
        request.httpBody = try? JSONSerialization.data(withJSONObject: body)
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        URLSession.shared.dataTask(with: request) { (data, response, error) in
            if let error {
                print("registerUser")
                print("Error: \(error.localizedDescription)")
                return
            }
            guard let data, let response = response as? HTTPURLResponse else {
                print("registerUser")
                print("Invalid data or response")
                return
            }
            if response.statusCode == 201 { // successs response
                guard let jsonData = try? JSONSerialization.jsonObject(with: data, options: []) as? [String: Any] else {
                    print("registerUser")
                    print("Invalid data format")
                    return
                }
                let refreshToken = jsonData["refresh_token"] as? String
                let accessToken = jsonData["access_token"] as? String
                self.saveTokens(refreshToken, accessToken)
                print("registerUser")
                print("User successfuly registered")
                completion(response.statusCode)
            } else if response.statusCode == 422 || response.statusCode == 201 { // validation error response
                completion(response.statusCode)
            } else { // error response
                print("registerUser")
                print("Status code: \(response.statusCode)")
            }
        }.resume()
    }
    
    static func putProfileView(user: UserUpdateRequest) {
        guard var request = getRequest(url: "https://plannerok.ru/api/v1/users/me/") else { return }
        request.httpMethod = "PUT"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        let bearerToken = NetworkService.getBearerAccessToken()
        request.addValue(bearerToken, forHTTPHeaderField: "Authorization")
        
        do {
            let requestBody = try JSONEncoder().encode(user)
            request.httpBody = requestBody
        } catch {
            print("putProfileView")
            print("Error encoding user update request: \(error)")
            return
        }
        
        URLSession.shared.dataTask(with: request) { data, response, error in
            if let error {
                print("putProfileView")
                print("Error: \(error.localizedDescription)")
                return
            }
            guard let data, let response = response as? HTTPURLResponse else {
                print("putProfileView")
                print("Invalid data or response")
                return
            }
            if response.statusCode == 200  { // success response
                // didnt get json header
                print(data)
            } else if response.statusCode == 401 { // access token expired response
                refreshToken { token in
                    if token {
                        putProfileView(user: user)
                    }
                }
            } else { // if not success response
                print("putProfileView")
                print(response.statusCode)
            }
        }.resume()
    }
    
    static func refreshToken(completion: @escaping (Bool) -> Void) {
        guard var request = getRequest(url: "https://plannerok.ru/api/v1/users/refresh-token/") else { return }
        request.httpMethod = "POST"
        request.setValue(getBearerRefreshToken(), forHTTPHeaderField: "Authorization")
        URLSession.shared.dataTask(with: request) { data, response, error in
            if let error {
                print("refreshToken")
                print("Error: \(error.localizedDescription)")
                completion(false)
                return
            }
            guard let data, let response = response as? HTTPURLResponse else {
                print("refreshToken")
                print("Invalid data or response")
                completion(false)
                return
            }
            if response.statusCode == 200 { // successs response
                guard let jsonData = try? JSONSerialization.jsonObject(with: data, options: []) as? [String: Any] else {
                    print("refreshToken")
                    print("Invalid data format")
                    completion(false)
                    return
                }
                let newRefreshToken = jsonData["refresh_token"] as? String
                let newAccessToken = jsonData["access_token"] as? String
                saveTokens(newRefreshToken, newAccessToken)
                completion(true)
            } else { // error response
                print("refreshToken")
                print("Status code: \(response.statusCode)")
                completion(false)
            }
        }.resume()
    }
    
    static func checkJWT() {
        guard var request = getRequest(url: "https://plannerok.ru/api/v1/users/check-jwt/") else { return }
        request.httpMethod = "GET"
        request.setValue(getBearerAccessToken(), forHTTPHeaderField: "Authorization")
        URLSession.shared.dataTask(with: request) { data, response, error in
            if let error {
                print("checkJWT")
                print("Error: \(error.localizedDescription)")
                return
            }
            guard let data, let response = response as? HTTPURLResponse else {
                print("checkJWT")
                print("Invalid data or response")
                return
            }
            if response.statusCode == 200 { // successs response
                do {
                    let message = try JSONDecoder().decode(String.self, from: data)
                    print(message)
                } catch {
                    print(error.localizedDescription)
                }
            } else if response.statusCode == 401 {  // access token expired response
                refreshToken { tokens in
                    checkJWT()
                }
            } else { // error response
                print("checkJWT")
                print("Status code: \(response.statusCode)")
            }
        }.resume()
    }
}
