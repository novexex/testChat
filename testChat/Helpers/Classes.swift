//
//  Classes.swift
//  testChat
//
//  Created by Artour Ilyasov on 31.03.2023.
//

import Foundation

class UserViewModel: ObservableObject {
    @Published var user: UserProfile?
    
    func fetchUser() {
        guard let url = URL(string: "https://plannerok.ru/api/v1/users/me/") else { return }
        var request = URLRequest(url: url)
        
        guard let accessToken = UserDefaults.standard.string(forKey: "access_token") else { return }
        
        let bearerToken = "Bearer " + accessToken
        request.addValue(bearerToken, forHTTPHeaderField: "Authorization")
        request.httpMethod = "GET"
        
        URLSession.shared.dataTask(with: request) { data, response, error in
            guard let data, error == nil else {
                print(error?.localizedDescription ?? "Unknown error")
                return
            }
            
            if let httpResponse = response as? HTTPURLResponse {
                print("Status code: \(httpResponse.statusCode)")
            }
            
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
        }.resume()
    }
}

