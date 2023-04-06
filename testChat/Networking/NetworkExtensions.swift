//
//  NetworkExtensions.swift
//  testChat
//
//  Created by Artour Ilyasov on 06.04.2023.
//

import Foundation

extension AuthorizationView {
    func sendAuthCode(_ phoneNumber: String) {
        guard var request = NetworkService.getRequest(url: "https://plannerok.ru/api/v1/users/send-auth-code/") else { return }
        request.httpMethod = "POST"
        let body: [String: Any] = ["phone": phoneNumber]
        request.httpBody = try? JSONSerialization.data(withJSONObject: body, options: [])
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        URLSession.shared.dataTask(with: request) { data, response, error in
            if let error {
                print("sendAuthCode")
                print("Error: \(error.localizedDescription)")
                return
            }
            guard let response = response as? HTTPURLResponse else {
                print("sendAuthCode")
                print("Invalid data or response")
                return
            }
            if response.statusCode == 201 { // successs response
                presentingConfirmationCodeView = true
            } else {  // error response
                print("sendAuthCode")
                print("Status code: \(response.statusCode)")
            }
        }.resume()
    }
}
