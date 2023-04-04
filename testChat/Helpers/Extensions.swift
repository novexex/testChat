//
//  Extensions.swift
//  testChat
//
//  Created by Artour Ilyasov on 31.03.2023.
//

import Foundation

extension AuthorizationView {
    func sendAuthCode(_ phoneNumber: String) {
        let url = URL(string: "https://plannerok.ru/api/v1/users/send-auth-code/")!
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        let body: [String: Any] = ["phone": phoneNumber]
        request.httpBody = try? JSONSerialization.data(withJSONObject: body, options: [])
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        URLSession.shared.dataTask(with: request) { data, response, error in
            if let error = error {
                print("Error: \(error)")
                return
            }
            guard let response = response as? HTTPURLResponse else {
                print("Invalid data or response")
                return
            }
            if response.statusCode == 201 { // successs response
                isConfirmationCodePresented = true
            } else {  // error response
                print("Status code: \(response.statusCode)")
            }
        }.resume()
    }
    
    func countryFlag(_ countryCode: String) -> String {
        let flagBase = UnicodeScalar("🇦").value - UnicodeScalar("A").value
        let flag = countryCode
            .uppercased()
            .unicodeScalars
            .compactMap({ UnicodeScalar(flagBase + $0.value)?.description })
            .joined()
        
        return flag
    }
}

