//
//  NetworkObject.swift
//  testChat
//
//  Created by Artour Ilyasov on 31.03.2023.
//

import Foundation

class NetworkObject: ObservableObject {
    @Published var user: UserProfile?
    
    func fetchUser() {
        guard var request = NetworkService.getRequest(url: "https://plannerok.ru/api/v1/users/me/") else { return }
        let bearerToken = NetworkService.getBearerAccessToken()
        request.addValue(bearerToken, forHTTPHeaderField: "Authorization")
        request.httpMethod = "GET"
        URLSession.shared.dataTask(with: request) { data, response, error in
            if let error {
                print("fetchUser")
                print("Error: \(error.localizedDescription)")
                return
            }
            guard let data, let response = response as? HTTPURLResponse else {
                print("fetchUser")
                print("Invalid data or response")
                return
            }
            if response.statusCode == 200 { // success response
                // for date
                let decoder = JSONDecoder()
                decoder.dateDecodingStrategy = .iso8601
                
                do {
                    let profileData = try decoder.decode(ProfileData.self, from: data)
                    DispatchQueue.main.async {
                        self.user = profileData.profileData
                    }
                } catch {
                    print(error.localizedDescription)
                }
            } else if response.statusCode == 401 { // access token expired response
                NetworkService.refreshToken { token in
                    if token {
                        self.fetchUser()
                    }
                }
            }
        }.resume()
    }
}

