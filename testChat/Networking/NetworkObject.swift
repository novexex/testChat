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
        guard let url = URL(string: "https://plannerok.ru/api/v1/users/me/") else { return }
        var request = URLRequest(url: url)
        
        let bearerToken = NetworkService.getBearerAccessToken()
        
        request.addValue(bearerToken, forHTTPHeaderField: "Authorization")
        request.httpMethod = "GET"
        
        URLSession.shared.dataTask(with: request) { data, response, error in
            guard let data, error == nil else {
                print(error?.localizedDescription ?? "Unknown error")
                return
            }
            
            let decoder = JSONDecoder()
            decoder.dateDecodingStrategy = .iso8601
            
            if let httpResponse = response as? HTTPURLResponse, httpResponse.statusCode == 200 {
                do {
                    let profileData = try decoder.decode(ProfileData.self, from: data)
                    DispatchQueue.main.async {
                        self.user = profileData.profileData
                    }
                } catch {
                    print(error.localizedDescription)
                }
            }
        }.resume()
    }
}

